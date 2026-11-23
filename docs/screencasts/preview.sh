#!/bin/bash

# Preview a .cast without building the docs -- the loop for judging timing
# (see the retiming section of README.md) is edit -> preview -> edit, and a full
# Sphinx build in the middle of that is dead weight.
#
# Two modes, because they answer different questions:
#
#   default     asciinema play inside the dotfiles container. Fast, and the
#               container is where asciinema actually lives (the host is not
#               required to have it). Good enough for "is that pause too long".
#
#   --browser   the vendored asciinema-player, same assets and CSS the docs use,
#               served over http on localhost. This is the pixel-accurate view:
#               the player's own idea of playback speed, and the subset Nerd
#               Font, both of which differ from your terminal's.
#
# Browser mode serves rather than opening a file:// page on purpose. The player
# loads recordings with fetch(), and browsers refuse cross-file fetches from
# file://; a local http server also sidesteps the file:// font restrictions that
# would silently swap the Nerd Font for tofu.

set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
STATIC=$(cd "$HERE/../_static" && pwd)
IMAGE=${DOTFILES_IMAGE:-dotfiles}

usage() {
  cat <<'EOF'
usage: preview.sh [options] CAST [-- extra args for `asciinema play`]

  -s, --speed N              playback speed multiplier
  -i, --idle-time-limit N    cap idle time (see the caveat in README.md)
      --loop                 loop playback (browser only)
      --autoplay             start immediately (browser only; default is to
                             show a poster and wait for a click)
      --pause-on-markers     stop at each marker (both modes; needs a cast that
                             has been through `timing.py --annotate`)
      --port N               http port for browser mode (default: ephemeral)
      --no-open              print the URL instead of launching a browser
  -h, --help                 this

examples:
  ./preview.sh casts/telescope.cast               # browser, docs' player and fonts
  ./preview.sh casts/telescope.cast --autoplay    # start without a click
  ./preview.sh -s 2 casts/telescope.cast          # skim a long take
EOF
}

BROWSER=true
SPEED=
IDLE=
LOOP=false
AUTOPLAY=false
PAUSE_MARKERS=false
PORT=
OPEN=true
CAST=
PASSTHRU=()

while [ $# -gt 0 ]; do
  case $1 in
    -s|--speed) SPEED=$2; shift ;;
    -i|--idle-time-limit) IDLE=$2; shift ;;
    --loop) LOOP=true ;;
    --autoplay) AUTOPLAY=true ;;
    --pause-on-markers) PAUSE_MARKERS=true ;;
    --port) PORT=$2; shift ;;
    --no-open) OPEN=false ;;
    -h|--help) usage; exit 0 ;;
    --) shift; PASSTHRU+=("$@"); break ;;
    -*) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
    *)
      if [ -n "$CAST" ]; then echo "only one cast at a time: $1" >&2; exit 2; fi
      CAST=$1
      ;;
  esac
  shift
done

if [ -z "$CAST" ]; then usage >&2; exit 2; fi
# Bare names are resolved here first so `preview.sh telescope.cast` works from
# anywhere, which is how it gets used from the repo root.
if [ ! -f "$CAST" ] && [ -f "$HERE/$CAST" ]; then CAST=$HERE/$CAST; fi
if [ ! -f "$CAST" ]; then echo "no such cast: $CAST" >&2; exit 1; fi
CAST_DIR=$(cd "$(dirname "$CAST")" && pwd)
CAST_BASE=$(basename "$CAST")

# The segment table is the thing you are actually editing when you retime, so
# print it next to the playback rather than making it a separate step.
if command -v python3 >/dev/null 2>&1; then
  python3 "$HERE/timing.py" "$CAST_DIR/$CAST_BASE" --list >/dev/null 2>&1 \
    && python3 "$HERE/timing.py" "$CAST_DIR/$CAST_BASE" --list
fi

if ! $BROWSER; then
  CONTAINER=
  for c in podman docker; do
    if command -v "$c" >/dev/null 2>&1; then CONTAINER=$c; break; fi
  done
  if [ -z "$CONTAINER" ]; then
    echo "need podman or docker for terminal playback; use --browser instead" >&2
    exit 1
  fi

  ARGS=()
  [ -n "$SPEED" ] && ARGS+=(--speed "$SPEED")
  [ -n "$IDLE" ] && ARGS+=(--idle-time-limit "$IDLE")
  # asciinema 2.x has no marker support; it will complain rather than silently
  # ignoring the flag, which is the behaviour we want.
  $PAUSE_MARKERS && ARGS+=(--pause-on-markers)
  ARGS+=("${PASSTHRU[@]+"${PASSTHRU[@]}"}")

  # --platform: the image is built for amd64 (see README.md), and on Apple
  # silicon podman otherwise refuses to run it.
  # asciinema lives in ~/opt/bin in the image, which a non-login `bash -c` does
  # not pick up, hence the explicit PATH.
  exec "$CONTAINER" run --rm -it --platform linux/amd64 \
    -v "$CAST_DIR":/gifs:ro "$IMAGE" \
    bash -c 'export PATH=$HOME/opt/bin:$PATH; exec asciinema play "$@"' \
    _ "${ARGS[@]+"${ARGS[@]}"}" "/gifs/$CAST_BASE"
fi

# --- browser mode -----------------------------------------------------------

# Mirror the _static layout so custom.css's relative url('fonts/...') resolves
# unchanged; the point of this mode is to use the docs' assets, not a lookalike.
ROOT=$(mktemp -d "${TMPDIR:-/tmp}/cast-preview.XXXXXX")
trap 'rm -rf "$ROOT"' EXIT
cp -R "$STATIC/asciinema" "$STATIC/fonts" "$ROOT/"
cp "$STATIC/custom.css" "$ROOT/"
cp "$CAST_DIR/$CAST_BASE" "$ROOT/"

OPTS=()
[ -n "$SPEED" ] && OPTS+=("speed: $SPEED")
[ -n "$IDLE" ] && OPTS+=("idleTimeLimit: $IDLE")
$LOOP && OPTS+=("loop: true")
$AUTOPLAY && OPTS+=("autoplay: true")
$PAUSE_MARKERS && OPTS+=("pauseOnMarkers: true")
OPTS_JS=$(IFS=,; echo "${OPTS[*]+"${OPTS[*]}"}")

# .asciinema-embed wrapper: custom.css hangs the font and sizing rules off it,
# and those rules are half of what makes this preview representative.
cat > "$ROOT/index.html" <<EOF
<!doctype html>
<meta charset="utf-8">
<title>$CAST_BASE</title>
<link rel="stylesheet" href="asciinema/asciinema-player.css">
<link rel="stylesheet" href="custom.css">
<style>
  body { margin: 2em auto; max-width: 60em; font: 14px/1.4 system-ui, sans-serif; }
  h1 { font-size: 1em; font-weight: normal; color: #555; }
</style>
<h1>$CAST_BASE</h1>
<div class="asciinema-embed"><div id="player"></div></div>
<script src="asciinema/asciinema-player.min.js"></script>
<script>
  AsciinemaPlayer.create("$CAST_BASE", document.getElementById("player"), {${OPTS_JS}});
</script>
EOF

if [ -z "$PORT" ]; then
  PORT=$(python3 - <<'PY'
import socket
s = socket.socket()
s.bind(("127.0.0.1", 0))
print(s.getsockname()[1])
s.close()
PY
)
fi
URL="http://127.0.0.1:$PORT/"

echo "serving $CAST_BASE at $URL (Ctrl-C to stop)"
if $OPEN; then
  # Give the server a moment; opening the URL before it binds shows an error page
  # the user then has to reload past.
  ( sleep 0.5
    if command -v open >/dev/null 2>&1; then open "$URL"
    elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$URL"
    fi ) &
fi
# Not exec'd: the EXIT trap has to survive to clean up $ROOT.
python3 -m http.server --bind 127.0.0.1 --directory "$ROOT" "$PORT" >/dev/null || true

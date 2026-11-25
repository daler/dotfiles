#!/bin/bash

# Preview a .cast in the browser using the docs' player, CSS, and fonts,
# without building the docs.
#
# Runs on the HOST (not in the container): needs only python3 and a browser.
# Copies docs/_static's vendored asciinema-player, fonts and custom.css plus the
# cast into a temp dir, writes an index.html, and serves it on a random
# localhost port until Ctrl-C.
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
STATIC=$HERE/../_static

usage() {
  cat <<'EOF'
usage: preview.sh [options] CAST

  -s, --speed N              playback speed multiplier
      --autoplay             start immediately instead of waiting for a click
      --pause-on-markers     stop at each marker (needs `timing.py --annotate`)
      --no-open              print the URL instead of launching a browser
  -h, --help                 this
EOF
}

# OPTS entries are JS object-literal fragments (AsciinemaPlayer.create options),
# joined with commas into the {...} in index.html below. Values are not escaped.
OPTS=()
OPEN=true
CAST=

while [ $# -gt 0 ]; do
  case $1 in
    -s|--speed)
      [ $# -ge 2 ] || { echo "$1 needs a value" >&2; usage >&2; exit 2; }
      OPTS+=("speed: $2"); shift ;;
    --autoplay) OPTS+=("autoplay: true") ;;
    --pause-on-markers) OPTS+=("pauseOnMarkers: true") ;;
    --no-open) OPEN=false ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
    *) [ -z "$CAST" ] || { echo "only one cast at a time: $1" >&2; exit 2; }
       CAST=$1 ;;
  esac
  shift
done

[ -n "$CAST" ] || { usage >&2; exit 2; }
[ -f "$CAST" ] || { echo "no such cast: $CAST" >&2; exit 1; }
NAME=$(basename "$CAST")

# Print the segment table alongside playback; it's what you edit when retiming.
# Best-effort: a cast without markers (or a timing.py error) shouldn't block preview.
python3 "$HERE/timing.py" "$CAST" --list 2>/dev/null || true

# Mirror the _static layout so custom.css's relative url('fonts/...') resolves.
ROOT=$(mktemp -d "${TMPDIR:-/tmp}/cast-preview.XXXXXX")
trap 'rm -rf "$ROOT"' EXIT
cp -R "$STATIC/asciinema" "$STATIC/fonts" "$STATIC/custom.css" "$CAST" "$ROOT/"

# The .asciinema-embed wrapper is where custom.css hangs its font/sizing rules.
# The ${arr[*]+...} form keeps an empty OPTS from tripping `set -u` on old bash.
OPTS_JS=$(IFS=,; echo "${OPTS[*]+"${OPTS[*]}"}")
cat > "$ROOT/index.html" <<EOF
<!doctype html>
<meta charset="utf-8">
<title>$NAME</title>
<link rel="stylesheet" href="asciinema/asciinema-player.css">
<link rel="stylesheet" href="custom.css">
<style>
  body { margin: 2em auto; max-width: 60em; font: 14px/1.4 system-ui, sans-serif; }
  h1 { font-size: 1em; font-weight: normal; color: #555; }
</style>
<h1>$NAME</h1>
<div class="asciinema-embed"><div id="player"></div></div>
<script src="asciinema/asciinema-player.min.js"></script>
<script>
  AsciinemaPlayer.create("$NAME", document.getElementById("player"), {$OPTS_JS});
</script>
EOF

# Grab a free port up front (bind to 0, read it back) so the URL is known before
# the server starts. Tiny race if something else takes it meanwhile.
PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])')
URL="http://127.0.0.1:$PORT/"

echo "serving $NAME at $URL (Ctrl-C to stop)"
if $OPEN; then
  # `open` is macOS, `xdg-open` Linux.
  # Small delay so the browser doesn't hit the port before the server binds.
  ( sleep 0.5; open "$URL" 2>/dev/null || xdg-open "$URL" 2>/dev/null ) &
fi
# Not exec'd: the EXIT trap has to survive to clean up $ROOT.
python3 -m http.server --bind 127.0.0.1 --directory "$ROOT" "$PORT" >/dev/null || true

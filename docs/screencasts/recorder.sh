#!/bin/bash

# Record one take: nvim under `asciinema rec`, driven by an instruction script.
#
#   recorder.sh DEST.cast [DRIVER.sh]
#
# Runs INSIDE the container (rebuild-casts.sh / parallel-casts.sh invoke it via
# `podman run -v docs/screencasts:/gifs ...`), so /gifs is this directory and
# /dotfiles is the repo the nvim config comes from. Not meant to run on the host.
#
# Flow:
#   1. Make a private temp dir for marks/t0/logs and pin the pty size.
#   2. Start DRIVER in the background; it waits on /tmp/nvim.sock (lib.sh).
#   3. Foreground: `asciinema rec` nvim with caption.lua loaded into a temp
#      cast, until the driver sends :qa! (or the failure path below kills it).
#   4. If the driver failed: write DEST's basename + .log, exit 1.
#   5. Otherwise: timing.py folds $MARKS into the temp cast as markers and
#      prints the segment table; only then is it moved over DEST.
# Trimming to a start marker is NOT done here; the callers do that.
#
# Env: NVIM_ARGS, CAST_COLS/CAST_ROWS (default 150x40), KEEP_MARKS=1,
# FAST_RECORD=1, MARKS; plus anything lib.sh reads, since the driver inherits
# this environment.
#
# DEST is only replaced by a fully recorded and annotated take, so a failed
# re-take leaves the previous cast intact.

set -euo pipefail

DEST=$1
# Optional: driver script to run against the recorded nvim. If given, it is
# backgrounded here so a whole take needs only one terminal (its WAIT_NVIM polls
# for /tmp/nvim.sock, so starting it before nvim exists is fine). Its output is
# redirected to a log because writing to this terminal while asciinema is
# replaying nvim's pty would scribble over the live view.
DRIVER=${2:-}
BASE=${DEST%.cast}
WORKDIR=$(mktemp -d)
# Record here, not to DEST: asciinema --overwrite truncates its output as soon as
# recording starts, which would destroy the previous cast on a failed take.
TAKE=$WORKDIR/take.cast
# The marks log lives in this take's private temp dir, never on the shared /gifs
# mount, so parallel takes can't clobber each other. KEEP_MARKS=1 copies it (and
# t0) next to the cast as <name>.marks.txt / <name>.t0 -- the names timing.py
# --annotate looks for by default -- for debugging or re-annotating.
if [ -z "${MARKS:-}" ]; then
  MARKS=$WORKDIR/marks.txt
fi
export MARKS

cleanup() {
  status=$?
  trap - EXIT
  if [ "${KEEP_MARKS:-0}" = 1 ]; then
    cp -f "$MARKS" "$BASE.marks.txt" 2>/dev/null || true
    [ -n "${T0:-}" ] && cp -f "$T0" "$BASE.t0" 2>/dev/null || true
  fi
  rm -rf "$WORKDIR"
  exit "$status"
}
trap cleanup EXIT

# Optional: extra arguments for the recorded nvim, e.g. NVIM_ARGS='setup.sh' or
# NVIM_ARGS="-c 'cd /root/dockeruser/demo' scripts/summarize.py". Lets a take
# start with the file already open instead of spending its first seconds (and
# cmdline real estate) on a `:e`. Paths are relative to /dotfiles (see the cd
# below) and must already exist when the container starts -- fixtures the driver
# builds do not, so open those with lib.sh's SETUP instead.
NVIM_ARGS=${NVIM_ARGS:-}
T0=$WORKDIR/t0
LOG=$WORKDIR/driver.log
export RPC_ERRLOG=$WORKDIR/rpc.err
FAILED=$WORKDIR/driver-failed
FAILURE_LOG=$BASE.log
HERE=$(cd "$(dirname "$0")" && pwd)

# This non-login shell doesn't activate conda. Node lives in the npm env;
# R lives in base and must be visible before Neovim evaluates R.nvim's cond.
export PATH="$HOME/miniforge/envs/npm/bin:$HOME/opt/bin:$HOME/miniforge/bin:$PATH"
cd /dotfiles
rm -f /tmp/nvim.sock "$FAILURE_LOG"

# Fresh timeline log for this take. lib.sh's MARK appends here, and $T0 is the
# reference clock that lets timing.py convert those wall-clock marks into
# cast-relative marker events. Nanosecond precision matters: the header's own
# `timestamp` field is whole seconds only.
: > "$MARKS"

# Recorded terminal geometry. This is the single source of truth: the cast
# header records these dimensions and both the player and agg replay at exactly
# this size, so anything that lets the real terminal's size leak through shows
# up as wrapped/clipped output.
CAST_COLS=${CAST_COLS:-150}
CAST_ROWS=${CAST_ROWS:-40}

# Ask the terminal emulator to resize itself (xterm CSI 8 ; rows ; cols t).
# Best-effort only: tmux parses this and deliberately drops it, and plenty of
# emulators disable it, so it cannot be relied on -- hence the explicit pty size
# passed to asciinema below.
printf '\e[8;%d;%dt' "$CAST_ROWS" "$CAST_COLS"; sleep 0.5

# Pin the size of the pty asciinema allocates for the recorded program, which is
# what actually decides nvim's &columns/&lines. The flag has been renamed twice,
# so probe --help rather than pinning a version:
#   asciinema 3.x  --window-size COLSxROWS
#   (some builds)  --tty-size COLSxROWS
#   asciinema 2.x  --cols N --rows N
SIZE_ARGS=()
REC_HELP=$(asciinema rec --help 2>&1 || true)
if grep -q -- '--window-size' <<<"$REC_HELP"; then
  SIZE_ARGS=(--window-size "${CAST_COLS}x${CAST_ROWS}")
elif grep -q -- '--tty-size' <<<"$REC_HELP"; then
  SIZE_ARGS=(--tty-size "${CAST_COLS}x${CAST_ROWS}")
elif grep -q -- '--cols' <<<"$REC_HELP"; then
  SIZE_ARGS=(--cols "$CAST_COLS" --rows "$CAST_ROWS")
else
  echo "WARNING: asciinema has no size flag; recording inherits terminal size" >&2
fi
echo "recording geometry: ${SIZE_ARGS[*]:-inherited from terminal}" >&2

# NB: asciinema will not report a size *larger* than the real terminal in some
# versions, so if the cast header still shows your pane's dimensions, make the
# pane at least ${CAST_COLS}x${CAST_ROWS} (or record outside tmux).

date +%s.%N > "$T0"
if [ -n "$DRIVER" ]; then
  echo "driver: $DRIVER (output -> $LOG)" >&2
  # A driver that dies early (the classic: a relative `source` that misses
  # because we cd'd to /dotfiles, fatal under the driver's `set -e`) used to
  # leave asciinema recording an nvim splash screen that only a human `:qa!`
  # could end. Instead, tear the take down ourselves and leave a sentinel so the
  # foreground can report it rather than running timing.py over zero marks.
  (
    st=0
    bash "$DRIVER" >"$LOG" 2>&1 || st=$?
    [ "$st" -eq 0 ] && exit 0
    echo "*** driver exited $st ***" >> "$LOG"
    echo "$st" > "$FAILED"
    for ((i = 0; i < 100; i++)); do
      nvim --headless --server /tmp/nvim.sock --remote-expr 1 >/dev/null 2>&1 && break
      sleep 0.2
    done
    nvim --headless --server /tmp/nvim.sock --remote-send '<Esc>:qa!<CR>' \
      >/dev/null 2>&1 </dev/null || true
  ) &
fi
# -c takes one shell-interpreted string, so NVIM_ARGS is appended verbatim and
# may carry its own quoting and -c flags.
NVIM_CMD="nvim --listen /tmp/nvim.sock -c 'luafile /gifs/caption.lua'"
[ -n "$NVIM_ARGS" ] && NVIM_CMD="$NVIM_CMD $NVIM_ARGS"
echo "recorded command: $NVIM_CMD" >&2
asciinema rec -f asciicast-v3 --overwrite "${SIZE_ARGS[@]}" "$TAKE" -c "$NVIM_CMD"

if [ -s "$FAILED" ]; then
  cp "$LOG" "$FAILURE_LOG"
  if [ -s "$RPC_ERRLOG" ]; then
    printf '\n--- recent RPC errors ---\n' >> "$FAILURE_LOG"
    tail -n 100 "$RPC_ERRLOG" >> "$FAILURE_LOG"
  fi
  echo >&2
  echo "DRIVER FAILED (exit $(cat "$FAILED")); $DEST was left untouched. $FAILURE_LOG says:" >&2
  sed 's/^/  /' "$FAILURE_LOG" >&2
  exit 1
fi

# Fold the step marks into the cast as native asciicast v3 marker events, then
# show the segment table so the run can be retimed (see README.md). FAST_RECORD
# uses short sleeps during the take; restore their configured durations now.
TIMING_ARGS=()
[ "${FAST_RECORD:-0}" = 1 ] && TIMING_ARGS+=(--restore-dwells)
python3 "$HERE/timing.py" "$TAKE" --annotate --marks "$MARKS" --t0 "$T0" \
  "${TIMING_ARGS[@]}" --in-place --list
# Cross-filesystem (container /tmp -> /gifs mount), so this is a copy, not an
# atomic rename; fine since nothing reads DEST concurrently.
mv -f "$TAKE" "$DEST"


# Don't render to gif by default since we're embedding casts into the docs
# agg \
#   --font-family="JetBrainsMono Nerd Font Mono" \
#   --renderer resvg \
#   "$1" "${1%.cast}.gif"

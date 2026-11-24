#!/usr/bin/env bash
set -eo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
JOBS=2

usage() {
  echo "Usage: $0 [-j JOBS] CAST [CAST ...]"
  echo "       $0 [-j JOBS] --all"
  echo
  echo "Record casts in separate Podman containers (default: 2 at once)."
  echo "Outputs: casts/<name>.cast and casts/<name>.recording.log"
  echo "Uses the existing 'dotfiles' image; build it first as in README.md."
  echo "Environment: FAST_RECORD (1), MIN_DWELL (0.1), KEEP_MARKS (0),"
  echo "             WAIT_SHOW (0.5), CAST_COLS (150), CAST_ROWS (40)."
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -j|--jobs)
      [[ $# -ge 2 && $2 =~ ^[1-9][0-9]*$ ]] || {
        echo "--jobs requires a positive integer" >&2; exit 2;
      }
      JOBS=$2
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) break ;;
  esac
done
[[ $# -gt 0 ]] || { usage >&2; exit 2; }

if [[ $1 == --all && $# == 1 ]]; then
  set --
  for script in "$HERE"/instructions/*_instructions.sh; do
    name=${script##*/}
    set -- "$@" "${name%_instructions.sh}"
  done
fi

# Validate the entire selection before launching anything, including duplicates
# which would otherwise overwrite the same cast and log.
selected=' '
for name in "$@"; do
  [[ $name =~ ^[a-zA-Z0-9_-]+$ && -f "$HERE/instructions/${name}_instructions.sh" ]] || {
    echo "Unknown cast: $name" >&2; exit 2;
  }
  [[ $selected != *" $name "* ]] || {
    echo "Duplicate cast: $name" >&2; exit 2;
  }
  selected="$selected$name "
done
command -v podman >/dev/null || { echo "podman is required" >&2; exit 1; }
mkdir -p "$HERE/casts"

record() {
  local name=$1 container=$2 start=0
  # This take replays fugitive2's setup before its own demo begins.
  if [[ $name == vim-fugitive3 ]]; then
    start=$(grep -E '^NV' "$HERE/instructions/vim-fugitive2_instructions.sh" | awk 'END{print NR-1}')
  fi
  # No terminal emulator is attached to answer Neovim's startup queries.
  # This must be set before startup; :set nottyfast happens too late.
  podman run -v "$HERE:/gifs" \
    --platform linux/amd64 \
    -e FAST_RECORD="${FAST_RECORD:-1}" \
    -e MIN_DWELL="${MIN_DWELL:-0.1}" \
    -e KEEP_MARKS="${KEEP_MARKS:-0}" \
    -e WAIT_SHOW="${WAIT_SHOW:-0.5}" \
    -e CAST_COLS="${CAST_COLS:-150}" \
    -e CAST_ROWS="${CAST_ROWS:-40}" \
    -e NVIM_NOTTYFAST=1 \
    --name "$container" --rm -t dotfiles \
    bash -c '
      set -e
      # Allocate and size an independent PTY, without attaching host stdin.
      stty cols "$CAST_COLS" rows "$CAST_ROWS" < /dev/tty
      bash /gifs/recorder.sh "$1" "$2"
      # Keep :qa! and its terminal teardown as the closing transition.
      python3 /gifs/timing.py "$1" --trim-start "marker:$3" --in-place
    ' bash "/gifs/casts/$name.cast" "/gifs/instructions/${name}_instructions.sh" "$start"
}

# Indexed arrays and polling also work with macOS's bundled Bash (no wait -n).
pids=()
names=()
containers=()
failed=0
serial=0

interrupt() {
  trap '' INT TERM
  echo "Stopping recording containers..." >&2
  for container in "${containers[@]}"; do
    podman rm -f "$container" >/dev/null 2>&1 || true
  done
  for pid in "${pids[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
  wait || true
  exit 130
}
trap interrupt INT TERM

reap() {
  local i
  for i in "${!pids[@]}"; do
    if ! kill -0 "${pids[$i]}" 2>/dev/null; then
      if wait "${pids[$i]}"; then
        echo "DONE ${names[$i]}"
      else
        echo "FAIL ${names[$i]} — see $HERE/casts/${names[$i]}.recording.log" >&2
        failed=1
      fi
      unset 'pids[i]' 'names[i]' 'containers[i]'
    fi
  done
}

for name in "$@"; do
  while (( ${#pids[@]} >= JOBS )); do
    reap
    sleep 0.2
  done
  serial=$((serial + 1))
  container="cast-parallel-$$-$serial"
  echo "START $name (log: $HERE/casts/$name.recording.log)"
  record "$name" "$container" >"$HERE/casts/$name.recording.log" 2>&1 &
  pids[$serial]=$!
  names[$serial]=$name
  containers[$serial]=$container
done

while (( ${#pids[@]} )); do
  reap
  sleep 0.2
done
exit "$failed"

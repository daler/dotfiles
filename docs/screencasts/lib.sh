# /gifs/lib.sh
export HOME=${HOME:-/root/dockeruser}
export PATH="$HOME/opt/bin:$PATH"
SOCK=/tmp/nvim.sock

KEYCAST=${KEYCAST:-1}          # 1 = show the keys being sent in a corner float
RPC_ERRLOG=${RPC_ERRLOG:-/tmp/rpc.err}
VERBOSE=${VERBOSE:-1}          # 1 = report overlay RPC failures on stderr
CAP_STYLE=${CAP_STYLE:-reverse}   # caption look: 'reverse' (solid block) or 'bold'
MARKS=${MARKS:-/tmp/marks.txt}    # timeline log consumed by timing.py --annotate (recorder.sh sets a per-take path)
WAIT_SHOW=${WAIT_SHOW:-0.5}        # max seconds a WAIT_* occupies in the final cast
FAST_RECORD=${FAST_RECORD:-0}      # 1 = shorten SAY/NV sleeps; recorder restores them later
MIN_DWELL=${MIN_DWELL:-0.1}        # sleep used by FAST_RECORD (never lengthens a shorter dwell)

# ---------------------------------------------------------------------------
# Why RPC() looks like this:
# `--remote-send` is nvim_input(), which is a "fast" API call and is always
# serviced, even while nvim sits in a getcharstr() loop (which-key popup,
# input(), etc). `--remote-expr` is nvim_eval(), which is NOT fast: while nvim
# is blocked on a keystroke the request is queued until nvim unblocks. So the
# cosmetic overlays (captions, keycast) must never be fatal and must not stall
# the script -- they get short timeouts and optional retries instead.
# ---------------------------------------------------------------------------

# Evaluate a vim expression in the recorded nvim.
# $1 = expression, $2 = attempts (default 1), $3 = per-attempt timeout (default 1)
# Returns nonzero on failure but never aborts the caller.
RPC() {
  local expr=$1 tries=${2:-1} tmo=${3:-1} i
  for ((i = 0; i < tries; i++)); do
    if timeout "$tmo" nvim --headless --server "$SOCK" \
         --remote-expr "$expr" >/dev/null 2>>"$RPC_ERRLOG" </dev/null; then
      return 0
    fi
    sleep 0.2
  done
  return 1
}

# Like RPC but prints the expression's value on stdout.
EVAL() {
  timeout "${2:-1}" nvim --headless --server "$SOCK" \
    --remote-expr "$1" 2>>"$RPC_ERRLOG" </dev/null || true
}

# Wait until any terminal buffer contains a line matching a Lua pattern.
# $1 = pattern, $2 = timeout (default 15), $3 = seconds to show (default
# $WAIT_SHOW). The wait itself is real (not shortened by FAST_RECORD), so it
# can guard commands sent to a REPL whose startup time varies between
# machines; timing.py then compresses it in the cast (see WAIT_SPAN).
WAIT_TERMINAL_PATTERN() {
  local pattern=$1 limit=${2:-15} show=${3:-$WAIT_SHOW} deadline result start
  start=$(date +%s.%N)
  deadline=$((SECONDS + limit))
  while ((SECONDS < deadline)); do
    result=$(EVAL "luaeval('(function(pattern) for _, buf in ipairs(vim.api.nvim_list_bufs()) do if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == \"terminal\" then for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do if line:match(pattern) then return \"true\" end end end end return \"false\" end)(_A)', '$(vq "$pattern")')")
    [ "$result" = true ] && { WAIT_SPAN "$start" "$show" "terminal:$pattern"; return 0; }
    sleep 0.1
  done
  echo "terminal did not become ready (pattern: $pattern)" >&2
  return 1
}

# Escape a string for embedding in a single-quoted vim string.
vq() { local s=${1//\'/\'\'}; printf '%s' "$s"; }

# Wait until a Lua chunk returns true in the recorded nvim, e.g.
#
#   WAIT_LUA 'return #vim.diagnostic.get(0) >= 3' 30
#
# Use this for anything asynchronous whose latency varies (language servers
# attaching, a formatter finishing). $3 = seconds to show (default $WAIT_SHOW).
# Like WAIT_TERMINAL_PATTERN it is not shortened by FAST_RECORD, and it does not
# add a marker (segment table rows are unchanged); instead timing.py compresses
# the waited span to at most $3 seconds, so the final cast doesn't depend on
# how fast the recording machine was.
WAIT_LUA() {
  local chunk=$1 limit=${2:-15} show=${3:-$WAIT_SHOW} deadline start
  start=$(date +%s.%N)
  deadline=$((SECONDS + limit))
  while ((SECONDS < deadline)); do
    if [ "$(EVAL "luaeval('loadstring(_A)() and \"true\" or \"false\"', '$(vq "$chunk")')")" = true ]; then
      WAIT_SPAN "$start" "$show" "lua:$chunk"
      return 0
    fi
    sleep 0.2
  done
  echo "timed out after ${limit}s waiting for: $chunk" >&2
  return 1
}

# Instead of sending all at once, do letter-by-letter typing
# $1 is full string
# $2 is optional override of pause between simulated keystrokes
TYPE() {
  local s=$1 d=${2:-0.04}
  MARK "type:$s"
  for ((i=0;i<${#s};i++)); do
    nvim --headless --server "$SOCK" --remote-send "${s:$i:1}" >/dev/null 2>&1 </dev/null || true
    sleep "$d"
  done
}

WAIT_NVIM() {
  local i up=0
  for ((i = 0; i < 100; i++)); do
    if nvim --headless --server "$SOCK" --remote-expr '1' >/dev/null 2>&1; then
      up=1; sleep 1.5; break
    fi
    sleep 0.2
  done
  [ "$up" = 1 ] || { echo "nvim never came up" >&2; exit 1; }
  # Each take starts a fresh nvim that luafile's caption.lua, so whatever is on
  # disk is what is loaded -- just confirm the overlays are actually there
  # (a syntax error in caption.lua leaves nvim running but CAP undefined, which
  # would otherwise show up only as a cast with no captions in it).
  if [ "$(EVAL "luaeval('tostring(CAP ~= nil)')")" != "true" ]; then
    echo "WARNING: caption.lua did not load; captions/keycast will be missing" >&2
  fi
  # Overlay look is a shell-side knob so a take can be re-run in a different
  # style without editing caption.lua.
  RPC "luaeval('(function() vim.g.cap_style = _A return 1 end)()', '$(vq "$CAP_STYLE")')" 3 1 \
    || echo "could not set cap_style=$CAP_STYLE" >&2
  echo "columns=$(EVAL '&columns') lines=$(EVAL '&lines') cap_width=$(EVAL "luaeval('tostring(CAPWIDTH and CAPWIDTH() or -1)')")" >&2
}

# Run ex commands *invisibly*: goes over RPC as a nvim_eval, so nothing is typed
# into the cmdline, no keycast float appears, and no timeline mark is logged.
# Use for stage-setting the take (:cd, :e, window layout) that is plumbing
# rather than part of the story being demonstrated:
#
#   SETUP "cd $DEMO_REPO" "e scripts/summarize.py"
#
# Prefer recorder.sh's NVIM_ARGS when the file exists before the container
# starts; SETUP is the option for fixtures the driver itself just created.
# Retries like SAY, since nvim may still be busy with startup/LSP attach.
SETUP() {
  local cmd
  for cmd in "$@"; do
    RPC "luaeval('(function() vim.cmd(_A) return 1 end)()', '$(vq "$cmd")')" 5 2 \
      || { [ "$VERBOSE" = 1 ] && echo "SETUP failed: $cmd (see $RPC_ERRLOG)" >&2; true; }
  done
}

# $1 = caption text ('' clears); $2 = dwell (default 1.4); $3 = corner
#      (NE default, or NW/SE/SW to dodge a popup or telescope window)
# Long text is word-wrapped by CAP(); use '\n' for a hard line break.
# Captions matter, so retry across the dwell: if nvim is momentarily busy
# (startup, LSP/treesitter attach, a blocking popup) a later attempt wins.
SAY() {
  local t=$1 pos=${3:-NE} dwell=${2:-1.4} actual extra
  read -r actual extra < <(RECORD_DWELL "$dwell")
  MARK "say:$t" "$extra"
  RPC "luaeval('CAP(_A[1], _A[2])', ['$(vq "$t")', '$pos'])" 5 1 \
    || { [ "$VERBOSE" = 1 ] && echo "SAY failed: $t (see $RPC_ERRLOG)" >&2; true; }
  sleep "$actual"
}

# Send keys to the recorded nvim, optionally showing them in the keycast float.
# The keycast gets a single short attempt: if nvim is blocked in which-key,
# retrying is pointless (by the time it unblocks the key is already consumed).
NV() {
  local dwell=${2:-0.4} actual extra
  read -r actual extra < <(RECORD_DWELL "$dwell")
  if [ "$KEYCAST" = 1 ]; then
    # Keep keys readable before clearing, even when fast recording shortens sleeps.
    read -r actual extra < <(awk -v actual="$actual" -v extra="$extra" 'BEGIN {
      desired = actual + extra
      actual = (actual < 1 ? 1 : actual)
      extra = (desired > actual ? desired - actual : 0)
      printf "%.6f %.6f\n", actual, extra
    }')
  fi
  MARK "nv:$1" "$extra"
  if [ "$KEYCAST" = 1 ]; then
    RPC "luaeval('KEYS(_A[1], _A[2])', ['$(vq "$1")', '${KEYCAST_POS:-SE}'])" 1 1 \
      || { [ "$VERBOSE" = 1 ] && echo "keycast skipped: $1" >&2; true; }
  fi
  nvim --headless --server "$SOCK" --remote-send "$1" >/dev/null 2>&1 </dev/null || true
  sleep "$actual"
  # Clear before the settled frame is held by FAST_RECORD's dwell restoration.
  if [ "$KEYCAST" = 1 ]; then
    RPC "luaeval('KEYS(\"\")')" 1 1 || true
  fi
}

# Print the sleep to use now and the hold timing.py should put back later.
# Keeping the two values together avoids float arithmetic in shell.
RECORD_DWELL() {
  awk -v desired="$1" -v minimum="$MIN_DWELL" -v fast="$FAST_RECORD" 'BEGIN {
    actual = (fast == 1 && desired > minimum) ? minimum : desired
    printf "%.6f %.6f\n", actual, desired - actual
  }'
}

# Log 'epoch.nanos label' at the moment a step begins. In fast mode the optional
# tab-separated dwell adjustment is consumed by timing.py and is not retained in
# the native marker label.
MARK() {
  if [ "${2:-0}" != 0 ] && [ "${2:-0}" != "0.000000" ]; then
    printf '%s %s\tdwell=%s\n' "$(date +%s.%N)" "$1" "$2" >> "$MARKS"
  else
    printf '%s %s\n' "$(date +%s.%N)" "$1" >> "$MARKS"
  fi
}

# Log a completed wait: 'epoch.nanos wait:<desc>\tstart=<epoch.nanos>\tshow=N',
# stamped at the moment the wait ended. timing.py --annotate squeezes the
# [start, end] span down to at most N seconds and does not turn it into a
# marker. Tabs/newlines in desc would break the line format, so flatten them.
WAIT_SPAN() {
  local desc=${3//$'\t'/ }
  desc=${desc//$'\n'/ }
  printf '%s wait:%s\tstart=%s\tshow=%s\n' "$(date +%s.%N)" "$desc" "$1" "$2" >> "$MARKS"
}

#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/toggleterm_fixture.sh

MAKE_TOGGLETERM_FIXTURE

WAIT_NVIM
SETUP "let &shell = 'bash --rcfile $TOGGLETERM_RC_FIXTURE'" "e $TOGGLETERM_PY_FIXTURE" 'normal! gg'

SAY 'The same terminal can run a REPL -- here, IPython' 3.0 SW
NV ',t' 1.5
WAIT_TERMINAL_PATTERN '#'
TYPE 'ipython' 0.06
NV '<CR>' 0.5
WAIT_TERMINAL_PATTERN '^In %[[0-9]+%]:'

SAY ',q returns to the Python buffer' 2.5 SW
NV ',q' 1.2
SAY 'gxx on a Python line' 2.5 SW
NV 'gxx' 2.0

SAY 'gx preserves indentation and blank lines in IPython' 3.0 SW
NV '3GVjjj' 1.2
NV 'gx' 2.0

SAY ',w returns to IPython, ready for input' 2.5 SW
NV ',w' 1.2
TYPE 'summarize(values)'
NV '<CR>'
WAIT_TERMINAL_PATTERN 'total=93'
SAY 'The function is defined in this REPL session' 2.5 SW

NV '<Esc>:qa!<CR>' 0.5

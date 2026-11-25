#!/usr/bin/env bash
set -euo pipefail

# Absolute paths: recorder.sh cd's to /dotfiles before backgrounding this
# script, so a relative `source` dies under `set -e` and nvim is never driven.
source /gifs/lib.sh
source /gifs/setup/toggleterm_fixture.sh

# Prep runs while nvim is still starting up.
MAKE_TOGGLETERM_FIXTURE

WAIT_NVIM
SETUP "let &shell = 'bash --rcfile $TOGGLETERM_RC_FIXTURE'" "e $TOGGLETERM_SH_FIXTURE" 'normal! gg'

SAY '<leader>t opens a terminal in a vertical split, ready for input' 3.5 SW
NV ',t' 2.5
WAIT_TERMINAL_PATTERN '#'

SAY 'Use it like any other terminal.' 2.0 SW
TYPE 'echo "just an ordinary shell"' 0.06
NV '<CR>' 1.5
# Anchored: the echoed command line also contains the phrase, after the prompt.
WAIT_TERMINAL_PATTERN '^just an ordinary shell'

SAY '<leader>q returns to the text buffer' 2.5 SW
NV ',q' 1.2

SAY 'gxx sends the current line to the terminal' 2.5 SW
NV 'gxx' 2.0
WAIT_TERMINAL_PATTERN '^hello from Linux'

SAY 'Select the loop; gx sends it to the shell' 3.0 SW
NV '3GVjj' 1.2
NV 'gx' 2.5
WAIT_TERMINAL_PATTERN 'value: 42'

SAY '<leader>t again hides the terminal...' 2.0 SW
NV ',t' 1.2
SAY '...and brings it back, with its session intact' 2.5 SW
NV '<Esc>,t' 2.0

NV '<Esc>:qa!<CR>' 0.5

#!/usr/bin/env bash
# Cast: toggleterm, part 1 of 3 -- the terminal is just a shell. See README.md.
#
# The three toggleterm casts share setup/toggleterm_fixture.sh:
#
#   toggleterm   open/close with ,t; hop with ,q/,w; gxx and gx with bash
#   toggleterm2  the same keys driving IPython (a whole function survives)
#   toggleterm3  R/RMarkdown: ,cd sends a chunk and jumps to the next one
#
# Story order is deliberate: the mappings are not REPL-specific, so part 1
# proves that with plain bash before parts 2 and 3 reuse the same keys.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast-toggleterm --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/toggleterm.cast \
#       /gifs/instructions/toggleterm_instructions.sh
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
SAY ''
WAIT_TERMINAL_PATTERN '#'

SAY 'Use it like any other terminal.' 2.0 SW
TYPE 'echo "just an ordinary shell"' 0.06
NV '<CR>' 1.5
# Anchored: the echoed command line also contains the phrase, after the prompt.
WAIT_TERMINAL_PATTERN '^just an ordinary shell'

SAY '<leader>q hops to the text buffer, <leader>w back to the terminal' 4.0 SW
NV ',q' 2.0

SAY 'gxx sends the line under the cursor -- here a line of bash' 3.5 SW
NV 'gxx' 1.5
WAIT_TERMINAL_PATTERN '^hello from Linux'

SAY 'gx sends a visual selection: the whole loop arrives as one paste' 4.0 SW
NV '3GVjj' 1.5
NV 'gx' 2.0
WAIT_TERMINAL_PATTERN 'value: 42'

SAY '<leader>t again hides the terminal...' 2.5 SW
NV ',t' 2.0
SAY '...and brings it back, with its session intact' 3.0 SW
NV '<Esc>,t' 2.5

NV '<Esc>:qa!<CR>' 0.5

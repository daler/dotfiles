#!/usr/bin/env bash
# Cast: toggleterm, part 2 of 3 -- the same keys driving IPython. See
# toggleterm_instructions.sh for the series overview.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast-toggleterm2 --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/toggleterm2.cast \
#       /gifs/instructions/toggleterm2_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/toggleterm_fixture.sh

MAKE_TOGGLETERM_FIXTURE

WAIT_NVIM
SETUP "let &shell = 'bash --rcfile $TOGGLETERM_RC_FIXTURE'" "e $TOGGLETERM_PY_FIXTURE" 'normal! gg'

SAY 'Nothing in toggleterm is tied to a language: start any REPL in the terminal' 4.0 SW
NV ',t' 1.5
WAIT_TERMINAL_PATTERN '#'
TYPE 'ipython' 0.06
NV '<CR>' 0.5
WAIT_TERMINAL_PATTERN '^In %[[0-9]+%]:'

SAY 'The same mappings used for bash now drive IPython' 3.0 SW
NV ',q' 1.5
SAY 'gxx on a Python line' 2.5 SW
NV 'gxx' 2.0

SAY 'gx on a whole function: the blank line and the indentation\nboth survive the trip' 4.5 SW
NV '3GVjjj' 1.5
NV 'gx' 2.5

SAY 'The definition is live in that session, so just call it' 3.5 SW
NV '8G' 1.0
NV ',w'
TYPE 'summarize(values)'
NV '<CR>'
WAIT_TERMINAL_PATTERN 'total=93'

NV '<Esc>:qa!<CR>' 0.5

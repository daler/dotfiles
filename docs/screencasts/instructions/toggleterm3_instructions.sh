#!/usr/bin/env bash
# Cast: toggleterm, part 3 of 3 -- R/RMarkdown and the chunk-sending ,cd. See
# toggleterm_instructions.sh for the series overview.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast-toggleterm3 --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/toggleterm3.cast \
#       /gifs/instructions/toggleterm3_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/toggleterm_fixture.sh

MAKE_TOGGLETERM_FIXTURE

WAIT_NVIM
# Cursor on line 4, inside the first chunk.
SETUP "let &shell = 'bash --rcfile $TOGGLETERM_RC_FIXTURE'" "e $TOGGLETERM_RMD_FIXTURE" 'normal! ggjjj'

SAY 'Same workflow with R: open the terminal and start R' 3.5 SW
NV ',t' 1.5
WAIT_TERMINAL_PATTERN '#'
TYPE 'R --quiet' 0.06
NV '<CR>' 0.5
WAIT_TERMINAL_PATTERN '^> *$'
NV ',q' 1.5

SAY 'In RMarkdown, <leader>cd sends the current chunk and jumps to the next one.' 4.0 SW
NV ',cd' 3.0
# The names row R prints; the echoed assignment has 'control = 20, treated'.
WAIT_TERMINAL_PATTERN 'control%s+treated'

SAY 'So pressing it again runs the next chunk in the same R session\nand since this is the last one, it cycles back to the first one.' 4.0 SW
NV ',cd' 3.0
WAIT_TERMINAL_PATTERN 'total: 62'

NV ':qa!<CR>' 0.5

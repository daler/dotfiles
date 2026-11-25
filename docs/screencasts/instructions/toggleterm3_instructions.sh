#!/usr/bin/env bash
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
SAY ',q returns to the RMarkdown buffer' 2.0 SW
NV ',q' 1.2

SAY ',cd sends this chunk and jumps to the next' 3.0 SW
NV ',cd' 3.0
# The names row R prints; the echoed assignment has 'control = 20, treated'.
WAIT_TERMINAL_PATTERN 'control%s+treated'

SAY ',cd runs the next chunk in the same R session' 3.0 SW
NV ',cd' 3.0
WAIT_TERMINAL_PATTERN 'total: 62'
SAY 'The total uses counts from the first chunk' 2.5 SW

NV ':qa!<CR>' 0.5

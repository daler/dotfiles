#!/usr/bin/env bash
# Cast: vim-table-mode -- type, convert, and realign Markdown tables. See
# README.md and NEXT.md.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/vim-table-mode.cast \
#       /gifs/instructions/vim-table-mode_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/table_fixture.sh

MAKE_TABLE_FIXTURE

WAIT_NVIM
# render-markdown would draw over the table in normal mode and hide what
# table-mode is doing to the raw text; turn it on again at the very end.
SETUP "e $TABLE_FIXTURE" 'RenderMarkdown disable' 'normal! G'

SAY 'vim-table-mode keeps Markdown and ReST tables aligned as you type' 4.0
SAY ':TableModeEnable turns it on for this buffer' 3.0
NV ':TableModeEnable<CR>' 1.5

SAY 'Type a header row, separating columns with |' 3.0
NV 'i' 0.3
TYPE '| group | n | mean |' 0.08
NV '<CR>' 0.5
SAY '|| on the next line draws the header underline' 3.0
TYPE '||' 0.3
NV '<CR>' 1.0

SAY 'Each | realigns the table, so columns widen to fit as you go' 3.5
TYPE '| control | 1 | 1204 |' 0.08
NV '<CR>' 0.3
TYPE '| treated | 2 | 8004.5 |' 0.08
NV '<Esc>' 2.0

SAY 'Existing CSV becomes a table with :Tableize on a selection' 3.5
NV '5GV3j' 1.2
NV ':Tableize<CR>' 2.5
SAY '|| on a new line below the first row turns it into a header' 3.5
NV '5Go' 0.3
TYPE '||' 0.3
NV '<Esc>' 2.0

SAY 'With table mode off, edits can leave a table ragged...' 3.0
NV ':TableModeDisable<CR>' 1.0
SETUP "call search('s10')"
NV 'ciw' 0.3
TYPE 's10-rerun' 0.08
NV '<Esc>' 2.0
SAY '...and :TableModeRealign fixes that' 3.0
NV ':TableModeRealign<CR>' 2.5

SAY 'render-markdown then draws the finished tables' 3.0
NV ':RenderMarkdown enable<CR>' 3.0

NV ':qa!<CR>' 0.5

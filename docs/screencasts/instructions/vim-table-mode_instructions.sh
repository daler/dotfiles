#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/table_fixture.sh

MAKE_TABLE_FIXTURE

WAIT_NVIM
# render-markdown would draw over the table in normal mode and hide what
# table-mode is doing to the raw text; turn it on again at the very end.
SETUP "e $TABLE_FIXTURE" 'RenderMarkdown disable' 'normal! G'

SAY 'vim-table-mode keeps Markdown and ReST tables aligned as you type' 3.0
SAY ':TableModeEnable turns it on for this buffer' 2.0
NV ':TableModeEnable<CR>' 1.2

SAY 'Type a header row, separating columns with |' 2.5
NV 'i' 0.3
TYPE '| group | n | mean |' 0.08
NV '<CR>' 0.5
SAY '|| on the next line draws the header underline' 2.5
TYPE '||' 0.3
NV '<CR>' 1.0

SAY 'Columns realign as you type each |' 2.5
TYPE '| control | 1 | 1204 |' 0.08
NV '<CR>' 0.3
TYPE '| treated | 2 | 8004.5 |' 0.08
NV '<Esc>' 2.0

SAY 'Select the CSV rows, then run :Tableize' 3.0
NV '5GV3j' 1.2
NV ':Tableize<CR>' 2.0
SAY '|| on a new line below the first row turns it into a header' 2.5
NV '5Go' 0.3
TYPE '||' 0.3
NV '<Esc>' 2.0

SAY 'With table mode off, edits can leave a table ragged...' 2.5
NV ':TableModeDisable<CR>' 1.0
NV '/s10<CR>' 1.2
NV 'ciw' 0.3
TYPE 's10-rerun' 0.08
NV '<Esc>' 2.0
SAY '...and :TableModeRealign fixes that' 2.0
NV ':TableModeRealign<CR>' 2.5

SAY 'render-markdown then draws the finished tables' 2.5
NV ':RenderMarkdown enable<CR>' 3.0

NV ':qa!<CR>' 0.5

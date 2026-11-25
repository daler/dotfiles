#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'After finding a hunk, <leader>hs stages it' 3.5
NV ']h' 1.2
NV ',hs' 2.5
SAY 'The gutter changes to show that this hunk is staged' 3.0

SAY '<leader>hu undoes the most recent hunk stage' 3.0
NV ',hu' 2.5

SAY 'Select just the config assignment, then stage it' 3.0
NV ']h' 1.2
NV 'V' 2.0
NV ',hs' 2.5
SAY 'Only the selected change is staged' 2.5

SAY '<leader>hS stages every remaining change in this buffer' 3.5
NV ',hS' 2.5
SAY 'All changes in this file are now staged' 2.5

NV ':qa!<CR>' 0.5

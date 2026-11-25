#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

# summarize.py has three separate change blocks in its dirty working tree.
MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'gitsigns marks added and changed lines in the gutter' 3.5
SAY ']h and [h jump between changed hunks' 3.0
NV ']h' 1.8
NV ']h' 1.8
NV '[h' 1.8

SAY '<leader>hp previews the current hunk without leaving the file' 3.5
NV ',hp' 3.0
SAY 'Move the cursor to close the preview' 2.5 SW
NV 'j' 1.5

SAY 'ih is a text object for the current hunk' 3.0
NV ']h' 1.2
NV 'vih' 2.5
SAY 'Use ih with visual commands to select a hunk' 3.0
NV '<Esc>' 1.0

SAY 'Next: stage and unstage hunks' 2.5
NV ':qa!<CR>' 0.5

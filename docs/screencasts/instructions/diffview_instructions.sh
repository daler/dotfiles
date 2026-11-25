#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

# A small repo makes the file panel and revision range readable at 100 columns.
MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'diffview.nvim compares changes across multiple files' 2.5
SAY ':DiffviewOpen compares the working tree with the index' 3.0
NV ':DiffviewOpen<CR>' 2

SAY 'The left panel lists every changed file' 2.5 SW
SAY 'Tab and Shift-Tab move between file diffs' 3.0 SW
NV '<Tab>' 2.0
NV '<S-Tab>' 2.0

SAY 'Pass a git revision to compare a different range' 3.0 SW
NV ':DiffviewClose<CR>' 1.0
NV ':DiffviewOpen HEAD~2..HEAD<CR>' 2.5
SAY 'This shows everything changed in the last two commits' 3.5 SW
NV '<Tab>' 2.0

SAY 'Next: browse file and repository history' 2.5 SW
NV ':DiffviewClose<CR>' 1
NV ':qa!<CR>' 0.5

#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
# README.md has multiple committed revisions, unlike scripts/summarize.py.
SETUP "cd $DEMO_REPO" 'e README.md'

SAY 'diffview also provides a visual git history browser' 2.5
SAY ':DiffviewFileHistory with a path follows one file' 3
NV ':DiffviewFileHistory README.md<CR>' 2

SAY 'The panel lists commits that changed this file' 2.5 SW
NV 'j' 1.2
SAY 'Enter opens the selected commit as a diff' 3.0 SW
NV '<CR>' 3.5
NV ':DiffviewClose<CR>' 1

SAY 'Without a path, it browses the whole repository\n(bash alias: glv)' 4.0
NV ':DiffviewFileHistory<CR>' 2.5
NV 'j' 1.2
NV '<CR>' 3.0
SAY ':DiffviewClose returns to the file you were editing' 2.5 SW
NV ':DiffviewClose<CR>' 1

NV ':qa!<CR>' 0.5

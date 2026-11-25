#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM

# Silent setup: status window open; README.md is the first unstaged file.
SETUP "cd $DEMO_REPO" 'e scripts/summarize.py'
SETUP 'tab Git'

SAY 'Inline diffs are handy, but sometimes you want the whole file' 3.5

SAY 'dv on README.md opens a side-by-side diff' 3
NV 'gU' 1.0
NV 'dv' 2

# Target the working-tree buffer, not whichever pane Fugitive leaves focused.
SETUP "lua assert(vim.fn.win_gotoid(vim.fn.bufwinid('$DEMO_REPO/README.md')) == 1, 'README working-tree pane missing')"
NV ']c' 1.2
NV 'zn' 1.2
SAY 'In the working-tree pane, do pulls the original text from the index' 3.5
NV 'do' 2.5
SAY 'This discards the change. Undo with u' 2.5
NV 'u' 2

NV ':qa!<CR>' 0.5

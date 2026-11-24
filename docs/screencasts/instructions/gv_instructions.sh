#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/gv_repo.sh

MAKE_GV_REPO

WAIT_NVIM
SETUP "cd $GV_REPO" "e scripts/summarize.py"

SAY 'gv is a compact browser for Git history' 3.0
SAY ':GV opens the repository commit graph' 3.0
NV ':GV<CR>' 3.0

SAY 'This graph shows three topic branches and the commits that merged each one' 4.0
SAY 'Each row shows a commit, author, and relative date' 3.5
SAY 'Press Enter on a commit to inspect its patch' 3.0
NV 'jjj<CR>' 3.0

SAY 'Close the patch with q to return to the graph' 3.0
NV 'q' 2.0

SAY 'Close the graph with q' 2.0
NV 'q' 1.0

SETUP "call search('def main')"
SAY ':GV on a visual selection narrows history to the selected lines' 3.5
NV 'Vjjj:GV<CR>' 3.5
SAY 'This answers when a particular block changed, without leaving nvim' 4.0
NV 'q' 1.5

NV ':qa!<CR>' 0.5

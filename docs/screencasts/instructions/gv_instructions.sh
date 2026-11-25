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

SAY 'Three merged topic branches appear in the graph' 3.0
SAY 'Commit rows show the date, message, and author' 3.0
NV '/extract row formatter<CR>' 1.2
SAY 'Press Enter on a commit to inspect its patch' 3.0
NV '<CR>' 3.0

SAY 'Close the patch with q to return to the graph' 3.0
NV 'q' 2.0

SAY 'Close the graph with q' 2.0
NV 'q' 1.0

NV '/^def main<CR>' 1.2
SAY ':GV on a visual selection narrows history to the selected lines' 3.5
NV 'Vjjj' 2.0
NV ':GV<CR>' 3.0

NV ':qa!<CR>' 0.5

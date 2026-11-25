#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/merge_repo.sh

MAKE_MERGE_REPO

WAIT_NVIM
SETUP "cd $MERGE_REPO" "e report.py"

SAY 'vim-mergetool turns diff3 conflict markers into a focused two-way diff' 4.0
SAY ':MergetoolStart keeps the merged file left and the incoming version right' 4.0
NV ':MergetoolStart<CR>' 1.0
SETUP 'wincmd h'
SAY ':MergetoolStart: merged file left, incoming version right' 3.5 SW

SAY 'Only unresolved hunks are highlighted; already-merged code stays out of the way' 4.0 SW
SAY ']c and [c move between conflicts using standard diff navigation' 3.5 SW
NV 'gg' 1.2
NV ']c' 1.2
NV ']c' 1.2
NV '[c' 1.2
NV ']c' 1.2

SAY 'The merged file starts with our local version of each conflict' 3.5 SW
SAY ':diffget accepts the incoming version for just this hunk' 3.5 SW
NV ':diffget<CR>' 3.0

SAY 'Keep Results locally; accept ready from incoming' 3.0 SW
SAY 'Save, then stop the comparison' 2.5 SW
NV ':write<CR>' 2.0
SAY 'Confirm with y to save and close; Git staging is still needed' 3.5 SW
NV ':MergetoolStop<CR>' 1.5
TYPE 'y' 0.2
NV '<CR>' 2.5

NV ':qa!<CR>' 0.5

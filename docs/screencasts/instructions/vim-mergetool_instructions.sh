#!/usr/bin/env bash
# Cast: vim-mergetool -- resolve a two-hunk merge conflict. See README.md and NEXT.md.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/vim-mergetool.cast \
#       /gifs/instructions/vim-mergetool_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/merge_repo.sh

MAKE_MERGE_REPO

WAIT_NVIM
SETUP "cd $MERGE_REPO" "e report.py"

SAY 'vim-mergetool turns diff3 conflict markers into a focused two-way diff' 4.0
SAY ':MergetoolStart keeps the merged file left and the incoming version right' 4.0
NV ':MergetoolStart<CR>' 3.5
SETUP 'wincmd h'

SAY 'Only unresolved hunks are highlighted; already-merged code stays out of the way' 4.0 SW
SAY ']c and [c move between conflicts using standard diff navigation' 3.5 SW
NV ']c' 2.0
NV ']c' 2.0
NV '[c' 2.0

SAY 'The merged file starts with our local version of each conflict' 3.5 SW
SAY ':diffget accepts the incoming version for just this hunk' 3.5 SW
NV ':diffget<CR>' 3.0

SAY 'Leave the other hunk local, edit either result if needed, then save' 4.0 SW
SAY "In this case, let's say the 'Results' on the left is what we want to keep." 4.0 SW
NV ':write<CR>' 2.0
SAY ':MergetoolStop closes the comparison and confirms the resolution' 3.5 SW
NV ':MergetoolStop<CR>' 1.5
TYPE 'y' 0.2
NV '<CR>' 2.5

NV ':qa!<CR>' 0.5

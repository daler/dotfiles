#!/usr/bin/env bash
# Cast: diffview.nvim, part 2 of 2 -- browse history. See README.md and part 1.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/diffview2.cast \
#       /gifs/instructions/diffview2_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'diffview also provides a visual git history browser' 3.0
SAY ':DiffviewFileHistory with a path follows one file' 3.5
NV ':DiffviewFileHistory scripts/summarize.py<CR>' 3.5

SAY 'The panel lists commits that changed this file' 3.0 SW
NV 'j' 1.2
SAY 'Enter opens the selected commit as a diff' 3.0 SW
NV '<CR>' 3.5
NV ':DiffviewClose<CR>' 1.5

SAY 'Without a path, it browses the whole repository\n(bash alias: glv)' 4.0
NV ':DiffviewFileHistory<CR>' 3.5
NV 'j' 1.2
NV '<CR>' 3.0
SAY ':DiffviewClose returns to the file you were editing' 3.5 SW
NV ':DiffviewClose<CR>' 1.5

NV ':qa!<CR>' 0.5

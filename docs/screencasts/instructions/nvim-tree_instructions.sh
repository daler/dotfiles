#!/usr/bin/env bash
# Cast: nvim-tree -- browse files and stage an untracked file. See README.md.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast-nvim-tree --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/nvim-tree.cast \
#       /gifs/instructions/nvim-tree_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY '<leader>fb opens a file browser on the left' 3.0
NV ',fb' 3.0
SAY 'Enter expands directories or opens files' 3.0 SW
NV '/scripts<CR>' 1.2
NV '<CR>' 1.8
NV '/summarize.py<CR>' 1.2
NV '<CR>' 2.5

SAY '<leader>q and <leader>w move between the browser and editor' 3.5 SW
NV ',q' 1.5
SAY '- moves up one directory in the tree' 2.5 SW
NV '-' 1.8

SAY 'ga stages the file under the cursor; gu unstages it' 3.5 SW
NV '/notes.md<CR>' 1.2
NV 'ga' 2.5
NV 'gu' 2.5

SAY 'Press q in the browser—or <leader>fb—to close it' 3.5 SW
NV 'q' 2.0
NV ':qa!<CR>' 0.5

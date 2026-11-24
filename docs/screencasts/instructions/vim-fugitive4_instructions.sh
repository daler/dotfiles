#!/usr/bin/env bash
# Cast: vim-fugitive, part 4 of 4 -- side-by-side diff of one file. See README.md
# and part 1 for how the four fugitive casts fit together.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast-vim-fugitive4 --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/vim-fugitive4.cast \
#       /gifs/instructions/vim-fugitive4_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM

# Silent setup: status window open, cursor in the unstaged section.
SETUP "cd $DEMO_REPO" 'e scripts/summarize.py'
NV ':tab Git<CR>' 2

SAY 'Inline diffs are handy, but sometimes you want the whole file' 3.5

SAY 'dd on a file opens it in a side-by-side diff...' 3
NV 'gU' 1.0
NV 'dd' 3
SAY '...where do and dp pull or push individual changes\nbetween the two versions' 4

SAY 'diffview.nvim, in the next screencast, does the same across many files' 4

NV ':qa!<CR>' 0.5

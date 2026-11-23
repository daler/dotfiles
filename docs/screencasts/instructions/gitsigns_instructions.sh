#!/usr/bin/env bash
# Cast: gitsigns, part 1 of 3 -- navigate and inspect hunks. See README.md.
# The three parts: 1 inspect hunks, 2 stage/undo, 3 blame/side-by-side diff.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/gitsigns.cast \
#       /gifs/instructions/gitsigns_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

# summarize.py has two well-separated hunks in its dirty working tree.
MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'gitsigns marks added and changed lines in the gutter' 3.5
SAY ']h and [h jump between changed hunks' 3.0
NV ']h' 1.8
NV ']h' 1.8
NV '[h' 1.8

SAY '<leader>hp previews the current hunk without leaving the file' 3.5
NV ',hp' 3.0
SAY 'Move the cursor to close the preview' 2.5 SW
NV 'j' 1.5

SAY 'ih is a text object for the current hunk' 3.0
NV 'vih' 2.5
SAY 'Use it with visual commands—or stage selected lines with <leader>hs' 4.0
NV '<Esc>' 1.0

SAY 'Next: stage, undo, and compare changes without leaving the buffer' 4.0
NV ':qa!<CR>' 0.5

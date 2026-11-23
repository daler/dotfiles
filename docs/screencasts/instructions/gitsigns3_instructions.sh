#!/usr/bin/env bash
# Cast: gitsigns, part 3 of 3 -- blame and side-by-side diff. See README.md.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/gitsigns3.cast \
#       /gifs/instructions/gitsigns3_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py" "normal! 4G"

SAY '<leader>hb shows who last changed the current line' 3.5
NV ',hb' 3.0
SAY 'The popup includes the commit, author, date, and message' 3.5 SW
NV 'j' 1.5

SAY '<leader>hd compares this buffer with the git version' 3.5
NV ',hd' 3.5
SAY 'This is ordinary vim diff mode, so ]c and [c move between changes' 4.0 SW
NV ']c' 1.8
NV ']c' 1.8
NV '[c' 1.8

SAY 'Close the comparison to return to normal editing' 3.0 SW
NV ':diffoff! | only<CR>' 2.0
NV ':qa!<CR>' 0.5

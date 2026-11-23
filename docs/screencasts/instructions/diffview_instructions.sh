#!/usr/bin/env bash
# Cast: diffview.nvim, part 1 of 2 -- compare changes across files. See README.md.
# The two parts: 1 working tree/revision diffs, 2 file/repository history.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/diffview.cast \
#       /gifs/instructions/diffview_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

# A small repo makes the file panel and revision range readable at 100 columns.
MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'diffview.nvim compares changes across multiple files' 3.0
SAY ':DiffviewOpen compares the working tree with HEAD' 3.0
NV ':DiffviewOpen<CR>' 3.5

SAY 'The left panel lists every changed file' 3.0 SW
SAY 'Tab and Shift-Tab move between file diffs' 3.0 SW
NV '<Tab>' 2.0
NV '<S-Tab>' 2.0

SAY 'Pass a git revision to compare a different range' 3.0 SW
NV ':DiffviewClose<CR>' 1.0
NV ':DiffviewOpen HEAD~2<CR>' 3.5
SAY 'This shows everything changed in the last two commits' 3.5 SW
NV '<Tab>' 2.0

SAY 'Next: browse the history of a file or the whole repository' 4.0 SW
NV ':DiffviewClose<CR>' 1.5
NV ':qa!<CR>' 0.5

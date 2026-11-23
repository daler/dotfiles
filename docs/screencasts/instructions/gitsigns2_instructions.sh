#!/usr/bin/env bash
# Cast: gitsigns, part 2 of 3 -- stage and undo hunks. See README.md and part 1.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/gitsigns2.cast \
#       /gifs/instructions/gitsigns2_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'After finding a hunk, <leader>hs stages it' 3.5
NV ']h' 1.5
NV ',hs' 2.5
SAY 'The gutter changes to show that this hunk is staged' 3.0

SAY '<leader>hu undoes the most recent hunk stage' 3.0
NV ',hu' 2.5

SAY 'The same mapping stages only a visual selection' 3.0
NV ']h' 1.5
NV 'Vjj' 1.5
NV ',hs' 2.5
SAY 'Only those selected lines were added to the index' 3.5

SAY '<leader>hS stages every remaining change in this buffer' 3.5
NV ',hS' 2.5
SAY 'Next: inspect blame and open a side-by-side diff' 4.0

NV ':qa!<CR>' 0.5

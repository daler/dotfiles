#!/usr/bin/env bash
# Cast: vim-fugitive, part 2 of 4 -- staging. See README.md and part 1 for how
# the four fugitive casts fit together.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/vim-fugitive2.cast /gifs/vim-fugitive2_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO"
SETUP "e scripts/summarize.py"

# Silent setup: get back to where part 1 left off (status window open, inline
# diff showing for an unstaged file) without narrating it again.
NV ':tab Git<CR>' 2
NV '2gU' 0.8
NV '=' 1.5

SAY 'Inline diffs (=) are where incremental commits start' 3.0

SAY 'Visually select just the lines you want...' 2.5
NV 'jjVjj' 1.5
SAY '...and use - to stage only those. This is how to make incremental commits.' 4
NV '-' 3

SAY 'With the cursor on a filename, - stages the whole file' 3.5
NV 'gU' 1.2
NV '-' 2.5

SAY 'Staged changes move down into the staged section' 3.0
NV '1gs' 0.1

SAY 'Use - on a staged file or inline diff to toggle' 3.0
NV '-' 2.5
SAY 'See the next screencast for how to commit what you just staged' 4

NV ':qa!<CR>' 0.5

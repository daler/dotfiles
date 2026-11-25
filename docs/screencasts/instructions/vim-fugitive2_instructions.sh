#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO"
SETUP "e scripts/summarize.py"

# Silent setup: get back to where part 1 left off (status window open, inline
# diff showing for an unstaged file) without narrating it again.
SETUP 'tab Git' 'normal 2gU'
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
NV '1gs' 1.2

SAY 'Use - on a staged file to unstage it' 3.0
NV '-' 2.5
SAY 'Next: commit the staged changes' 2.5

NV ':qa!<CR>' 0.5

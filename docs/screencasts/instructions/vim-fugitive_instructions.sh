#!/usr/bin/env bash
set -euo pipefail

# Absolute paths: recorder.sh cd's to /dotfiles before backgrounding this
# script, so a relative `source` here dies under `set -e` and the take hangs on
# an undriven nvim splash screen.
source /gifs/lib.sh

# Prep: throwaway repo with history + a dirty working tree. Runs while nvim is
# still starting up; fugitive picks up the repo when :Git is first called.
source /gifs/setup/demo_repo.sh
MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO"
SETUP "e scripts/summarize.py"


SAY 'vim-fugitive is a git interface for nvim' 3.0
SAY ':tab Git opens status in a new tab\n(bash alias: gsv)' 3.5
NV ':tab Git<CR>' 2

SAY 'Sections for untracked, unstaged, and staged files' 3.5
SAY '2gU jumps to the second unstaged file' 2.5
NV '2gU' 1.5

SAY 'Toggle an inline diff for the file under the cursor with =' 3.5
NV '=' 2.5
NV '=' 1
SAY 'Use = on the heading to toggle all files' 3.0
NV 'kk' 1.2
NV '=' 2.5
NV '='
SAY 'See the next screencast for how to stage individual lines' 3

NV ':qa!<CR>' 0.5

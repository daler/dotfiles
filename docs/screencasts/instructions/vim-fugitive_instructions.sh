#!/usr/bin/env bash
# Cast: vim-fugitive, part 1 of 4 -- the status window. See README.md.
# The four parts: 1 status window, 2 staging, 3 committing, 4 side-by-side diff.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast-vim-fugitive --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/vim-fugitive.cast /gifs/vim-fugitive_instructions.sh
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
SAY ':Git opens the status window\n(bash alias: gsv).\n\nUsually you will want to open it with :tab Git' 3.0
NV ':tab Git<CR>' 3

SAY 'Sections for untracked, unstaged, and staged files' 3.5
SAY 'gU jumps to a file in the unstaged section' 3.0
NV '2gU' 1.5

SAY 'Toggle an inline diff for the file under the cursor with =' 3.5
NV '=' 2.5
NV '=' 1.5
SAY 'Use = on the heading to toggle all files' 3.0
NV 'kk'
NV '=' 2.0
NV '='
SAY ''
SAY 'See the next screencast for how to stage individual lines' 4

NV ':qa!<CR>' 0.5

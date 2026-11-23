#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO
WAIT_NVIM
SETUP "cd $DEMO_REPO"
SETUP "e scripts/summarize.py"

# Replay all of vim-fugitive2's NV commands, but drop the last line which quits nvim (and
# which otherwise exits the recording)
source <(sed -nE 's/^([[:space:]]*NV[[:space:]].*[[:space:]])[0-9]*\.?[0-9]+[[:space:]]*$/\10.1/p' \
        /gifs/instructions/vim-fugitive2_instructions.sh | grep -v ':qa!')

SAY 'Picking up where the last screencast left off:\na few lines of summarize.py are staged' 3.5

SAY ''
SAY "Show what's staged with ="
NV 'gs' 1.0
NV '=' 1.0
SAY 'cc opens a commit buffer' 2.5
NV 'cc' 2
NV 'i'

TYPE 'Import yaml package' 0.06
sleep 1
SAY 'Save and close the buffer to make the commit' 3
NV '<Esc>' 0.3
NV ':wq<CR>' 3
NV '<CR>'
NV ':qa!<CR>' 0.5

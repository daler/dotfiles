#!/usr/bin/env bash
# Add, change, and delete surrounding characters without retyping the word.
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/editing_fixture.sh
MAKE_EDITING_FIXTURE
WAIT_NVIM
SETUP "e $EDITING_FIXTURE/surround.py" "call search('control')"

SAY 'vim-surround edits the characters around existing text' 3.0
SAY 'ysiw followed by a quote surrounds the current word' 3.0
NV 'ysiw"' 2.5
WAIT_LUA 'return vim.fn.getline(1) == [[label = "control"]]' 5
SAY 'cs followed by the old and new delimiters changes them' 3.0
NV "cs\"'" 2.5
WAIT_LUA 'return vim.fn.getline(1) == [[label = '\''control'\'']]' 5
SAY 'Change quotes to parentheses without changing the text inside' 3.0
NV "cs')" 2.5
WAIT_LUA 'return vim.fn.getline(1) == [[label = (control)]]' 5
SAY 'ds followed by a delimiter removes the surrounding pair' 3.0
NV 'ds)' 2.5
WAIT_LUA 'return vim.fn.getline(1) == [[label = control]]' 5
NV ':qa!<CR>' 0.5

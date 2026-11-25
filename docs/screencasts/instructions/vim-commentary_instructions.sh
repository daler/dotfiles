#!/usr/bin/env bash
# Comment a line or selection, then restore it with the same operator.
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/editing_fixture.sh
MAKE_EDITING_FIXTURE
WAIT_NVIM
SETUP "e $EDITING_FIXTURE/comments.py" 'normal! gg'

SAY 'vim-commentary toggles comments using the current filetype' 3.0
SAY 'gcc comments the current line' 2.5
NV 'gcc' 2.5
WAIT_LUA 'return vim.fn.getline(1):match("^#") ~= nil' 5
SAY 'gcc again uncomments it' 2.5
NV 'gcc' 2.0
WAIT_LUA 'return vim.fn.getline(1) == "counts = [20, 42]"' 5
SAY 'Select several lines, then gc comments the selection' 3.0
NV '2GVj' 1.2
NV 'gc' 2.5
WAIT_LUA 'return vim.fn.getline(2):match("^#") and vim.fn.getline(3):match("^#")' 5
SAY 'Select the same lines and gc restores the code' 3.0
NV '2GVj' 1.2
NV 'gc' 2.5
WAIT_LUA 'return vim.fn.getline(2) == [[total = sum(counts)]] and vim.fn.getline(3) == [[print(total)]]' 5
NV ':qa!<CR>' 0.5

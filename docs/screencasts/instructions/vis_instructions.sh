#!/usr/bin/env bash
# Replace one TSV column, keeping identical text in the next column intact.
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/editing_fixture.sh
MAKE_EDITING_FIXTURE
WAIT_NVIM
SETUP "e $EDITING_FIXTURE/columns.tsv" 'setlocal nowrap tabstop=12 noexpandtab' 'normal! gg'

SAY 'A line-range substitution changes every matching column' 3.0
NV ':2,4s/old/new/g<CR>' 2.5
SAY 'Both group and note changed; undo before limiting the edit' 3.0
NV 'u' 2.0

SAY 'Ctrl-v selects a rectangular block: just the group column' 3.0
NV '2G0f<Tab>l<C-v>jjll' 2.0
SAY ':B applies an Ex command only inside that block' 3.0
NV ':B s/old/new/g<CR>' 2.5
# vis pads the extracted block when reinserting it between tab characters.
# Require the same three TSV fields, allowing padding only around "new".
WAIT_LUA 'for i = 2, 4 do if not vim.fn.getline(i):match(string.format("^s%d\t *new *\told$", i - 1)) then return false end end; return true' 5
SAY 'group is new; the identical old values in note are untouched' 3.5
NV ':qa!<CR>' 0.5

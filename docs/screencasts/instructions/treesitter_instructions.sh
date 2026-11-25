#!/usr/bin/env bash
# Structural selection uses the configured Neovim 0.12 Treesitter API.
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/editing_fixture.sh
MAKE_EDITING_FIXTURE
WAIT_NVIM
SETUP "e $EDITING_FIXTURE/selection.py" "call search('2')"
WAIT_LUA 'return type(vim.treesitter.select) == "function" and pcall(vim.treesitter.get_parser, 0, "python")' 10

SAY 'Treesitter selects syntax structure, not just characters' 3.0
SAY '<leader>cs starts a structural selection under the cursor' 3.0
NV ',cs' 2.0
WAIT_LUA 'return vim.fn.mode():match("[vV]") ~= nil' 5
SAY 'Tab expands to an enclosing syntax node' 2.5
NV '<Tab>' 2.0
NV '<Tab>' 2.0
SAY 'Shift-Tab shrinks the selection again' 2.5
NV '<S-Tab>' 2.0
SAY 'Use ordinary editing commands on the selected code' 3.0
NV 'c' 1.0
TYPE '0' 0.08
NV '<Esc>' 2.5
SAY 'u restores the code; selection itself does not change the file' 3.0
NV 'u' 2.0
NV ':qa!<CR>' 0.5

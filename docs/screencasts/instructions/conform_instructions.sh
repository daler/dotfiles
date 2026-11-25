#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/lsp_fixture.sh

MAKE_LSP_FIXTURE

WAIT_NVIM
# Add a second spacing issue only for this cast, leaving the shared LSP
# fixture (and its diagnostic expectations) unchanged.
SETUP "cd $LSP_FIXTURE" "e report.py" \
  "call setline('$', 'report( SAMPLES )')" "call search('SAMPLES =')"

SAY 'Conform formats Python with Ruff and Black' 3.0
SAY 'Both SAMPLES and the final report call have messy spacing' 2.5
SAY 'V selects this line; <leader>cf formats the selection' 3.0
NV 'V' 1.2
NV ',cf' 1.0
WAIT_LUA 'return vim.fn.getline(3) == [[SAMPLES = {"control": [20.0, 22.5], "treated": [41.0, 43.5]}]]' 20
WAIT_LUA 'return vim.fn.getline("$") == [[report( SAMPLES )]]' 5
SAY 'SAMPLES is formatted; the final call is unchanged' 3.0

NV '<Esc>' 0.3
SAY 'In normal mode, <leader>cf formats the whole buffer' 2.5
NV ',cf' 1.0
# Formatting is async; wait for the remaining issue outside the selection.
WAIT_LUA 'return vim.fn.getline("$") == [[report(SAMPLES)]]' 20
SAY 'The whole buffer is now formatted' 2.0

SAY 'Formatting changes the buffer; u undoes it' 2.5
NV 'u' 2.0
WAIT_LUA 'return vim.fn.getline("$") == [[report( SAMPLES )]]' 5
SAY 'Ctrl-r redoes it. Save separately to write the file' 3.0
NV '<C-r>' 2.0
WAIT_LUA 'return vim.fn.getline("$") == [[report(SAMPLES)]]' 5

NV ':qa!<CR>' 0.5

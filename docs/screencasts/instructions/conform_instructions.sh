#!/usr/bin/env bash
# Cast: conform -- format a selection or the buffer, as an undoable edit. See
# nvim-lspconfig_instructions.sh for the index of LSP casts (this one does not
# need a language server, only the formatters from mason.lua/setup.sh).
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/conform.cast \
#       /gifs/instructions/conform_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/lsp_fixture.sh

MAKE_LSP_FIXTURE

WAIT_NVIM
# Add a second spacing issue only for this cast, leaving the shared LSP
# fixture (and its diagnostic expectations) unchanged.
SETUP "cd $LSP_FIXTURE" "e report.py" \
  "call setline('$', 'report( SAMPLES )')" "call search('SAMPLES =')"

SAY 'conform runs code formatters on the buffer -- here ruff and black, for Python' 4.0
SAY 'Both SAMPLES and the final report call have messy spacing' 3.0
SAY 'Select just the SAMPLES line with V, then <leader>cf formats that region' 4.0
NV 'V' 1.2
NV ',cf' 1.0
WAIT_LUA 'return vim.fn.getline(3) == [[SAMPLES = {"control": [20.0, 22.5], "treated": [41.0, 43.5]}]]' 20
WAIT_LUA 'return vim.fn.getline("$") == [[report( SAMPLES )]]' 5
SAY 'Only the selection changed; the report call still has extra spaces' 3.5

NV '<Esc>' 0.3
SAY 'In normal mode, <leader>cf formats the whole buffer' 3.0
NV ',cf' 1.0
# Formatting is async; wait for the remaining issue outside the selection.
WAIT_LUA 'return vim.fn.getline("$") == [[report(SAMPLES)]]' 20
sleep 2.0

SAY 'Unlike running black on the file, this is an ordinary edit: u undoes it' 4.0
NV 'u' 2.5
SAY 'Ctrl-r redoes it. Nothing is written to disk until you save' 3.5
NV '<C-r>' 2.5

NV ':qa!<CR>' 0.5

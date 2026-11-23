#!/usr/bin/env bash
# Cast: nvim-lspconfig, part 2 of 2 -- definitions, references, rename.
# See nvim-lspconfig_instructions.sh for the index of LSP casts.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/nvim-lspconfig2.cast \
#       /gifs/instructions/nvim-lspconfig2_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/lsp_fixture.sh

MAKE_LSP_FIXTURE

WAIT_NVIM
SETUP "cd $LSP_FIXTURE" "e report.py"

# Silent replay of part 1: LSP on, diagnostics in.
SETUP 'normal ,cl'
WAIT_LUA 'local b = vim.fn.bufnr("report.py"); local clients = vim.lsp.get_clients({bufnr = b}); local found = {}; for _, c in ipairs(clients) do found[c.name] = true end; return found.pyright and found.ruff and #vim.diagnostic.get(b) >= 3' 60
SETUP "call search('describe(values)')"

SAY 'Picking up from the last screencast: the LSP is running on report.py' 3.5
SAY 'Ctrl-] jumps to the definition, even when it is in another file' 3.5
NV '<C-]>' 2.5

SETUP 'call cursor(5, 5)'
SAY 'grr lists every reference to mean, across both files' 3.5
NV 'grr' 3.0
SAY 'Enter on an entry jumps there' 2.5
NV 'j' 0.8
NV '<CR>' 2.0
NV ':cclose<CR>' 1.0

SAY 'grn renames the symbol everywhere it is used' 3.0
NV 'grn' 1.5
NV '<C-u>' 0.3
TYPE 'average' 0.08
NV '<CR>' 2.5

SAY 'Both files were edited. Ctrl-^ flips to the other one to check' 3.5
NV '<C-^>' 2.5
NV '<C-^>' 2.0
SAY ':wa saves them all' 2.5

SAY 'Next: an overview of every diagnostic with trouble.nvim' 3.5
NV ':qa!<CR>' 0.5

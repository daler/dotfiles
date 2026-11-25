#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/lsp_fixture.sh

MAKE_LSP_FIXTURE

WAIT_NVIM
SETUP "cd $LSP_FIXTURE" "e report.py"

# Silent replay of part 1: LSP on, diagnostics in.
SETUP 'normal ,cl'
WAIT_LUA 'local b = vim.fn.bufnr("report.py"); local clients = vim.lsp.get_clients({bufnr = b}); local found = {}; for _, c in ipairs(clients) do found[c.name] = true end; return found.pyright and found.ruff and #vim.diagnostic.get(b) >= 2' 60
SETUP "call search('describe(values)')"

SAY 'Definitions, references, and rename across two Python files' 3.0
SAY 'Ctrl-] jumps to the definition, even when it is in another file' 3.5
NV '<C-]>' 2.5

NV '5G0w' 1.2
SAY 'grr lists references to mean across both files' 3.0
NV 'grr' 3.0
SAY 'Enter on an entry jumps there' 2.5
NV 'j' 1.2
NV '<CR>' 2.0
NV ':cclose<CR>' 1.0

SAY 'grn renames this symbol across the project' 3.0
NV 'grn' 1.5
NV '<C-u>' 0.3
TYPE 'average' 0.08
NV '<CR>' 2.5

SAY 'Both files were edited. Ctrl-^ flips to the other one to check' 3.5
NV '<C-^>' 2.0
NV '<C-^>' 2.0
SAY ':wa saves both changed files' 2.0
NV ':wa<CR>' 1.5

SAY 'Next: an overview of diagnostics with trouble.nvim' 2.5
NV ':qa!<CR>' 0.5

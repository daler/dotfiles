#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/lsp_fixture.sh

MAKE_LSP_FIXTURE

WAIT_NVIM
SETUP "cd $LSP_FIXTURE" "e report.py"

SAY 'Start language servers with <leader>cl' 3.0
NV ',cl' 1.0
# pyright: bad argument; ruff: undefined name. Both servers
# have to be in before the diagnostics are worth narrating. Fatal on timeout,
# so a server missing from the image fails the take rather than recording an
# empty gutter.
WAIT_LUA 'local b = vim.fn.bufnr("report.py"); local clients = vim.lsp.get_clients({bufnr = b}); local found = {}; for _, c in ipairs(clients) do found[c.name] = true end; return found.pyright and found.ruff and #vim.diagnostic.get(b) >= 2' 60

SAY 'Pyright and Ruff show diagnostics beside the code' 3.0
SAY ']d: next diagnostic; [d: previous' 2.5
NV ']d' 1.2
NV ']d' 1.2
NV '[d' 1.2

SAY '<leader>ce opens the full diagnostic' 2.5
NV ',ce' 3.0
NV 'j' 1.0

SAY '<leader>cv hides or restores inline diagnostics' 2.5
NV ',cv' 1.5
NV ',cv' 1.5

SETUP "call search('describe(values)')"
SAY 'K shows documentation for the symbol under the cursor' 2.5
NV 'K' 3.0
NV 'j' 1.0

SAY 'Next: jump to definitions, find references, and rename across files' 2.5
NV ':qa!<CR>' 0.5

#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/lsp_fixture.sh

MAKE_LSP_FIXTURE

WAIT_NVIM
SETUP "cd $LSP_FIXTURE" "e report.py"

# Silent setup: LSP on in *both* files, so the list has more than one group.
# Opening stats.py after the plugin loads may already attach it (lspconfig
# calls vim.lsp.enable), in which case another <leader>cl would toggle it back
# off -- hence the guard.
SETUP 'normal ,cl'
WAIT_LUA 'return #vim.diagnostic.get(vim.fn.bufnr("report.py")) >= 2' 60
SETUP 'e stats.py' \
  'lua if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then vim.cmd.normal(",cl") end'
WAIT_LUA 'return #vim.diagnostic.get(vim.fn.bufnr("stats.py")) >= 1' 60
SETUP 'e report.py' 'normal! gg'

SAY 'Trouble collects diagnostics from loaded buffers' 3.0
SAY '<leader>ct toggles it at the bottom of the screen' 2.5
NV ',ct' 2.0

SAY 'Ctrl-w j focuses the list; j/k selects entries' 3.0
NV '<C-w>j' 1.2
NV 'j' 1.2
NV 'j' 1.2
NV 'j' 1.2

SAY 'Enter jumps to that problem in its file' 2.5
NV '<CR>' 2.5

SAY '<leader>ct again closes the list' 2.0
NV ',ct' 1.2

NV ':qa!<CR>' 0.5

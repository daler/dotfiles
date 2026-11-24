#!/usr/bin/env bash
# Cast: trouble.nvim -- every diagnostic in one list. See
# nvim-lspconfig_instructions.sh for the index of LSP casts.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast-trouble --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/trouble.cast \
#       /gifs/instructions/trouble_instructions.sh
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
WAIT_LUA 'return #vim.diagnostic.get(vim.fn.bufnr("report.py")) >= 3' 60
SETUP 'e stats.py' \
  'lua if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then vim.cmd.normal(",cl") end'
WAIT_LUA 'return #vim.diagnostic.get(vim.fn.bufnr("stats.py")) >= 1' 60
SETUP 'e report.py' 'normal! gg'

SAY 'trouble.nvim collects LSP diagnostics from every open file into one list' 4.0
SAY '<leader>ct toggles it at the bottom of the screen' 3.0
NV ',ct' 3.0

SAY 'Problems are grouped by file, so you can see everything at once' 3.5
SAY 'Ctrl-w j moves into the list; j and k move between entries' 3.5
NV '<C-w>j' 1.2
NV 'j' 0.8
NV 'j' 0.8
NV 'j' 1.2

SAY 'Enter jumps to that problem in its file' 3.0
NV '<CR>' 2.5

SAY '<leader>ct again closes the list' 3.0
NV ',ct' 2.0

NV ':qa!<CR>' 0.5

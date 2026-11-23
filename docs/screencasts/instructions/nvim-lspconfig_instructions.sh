#!/usr/bin/env bash
# Cast: nvim-lspconfig, part 1 of 2 -- start the LSP and read diagnostics.
# See README.md and NEXT.md. The LSP-related casts, all on setup/lsp_fixture.sh:
#
#   nvim-lspconfig   start LSP, ]d/[d, <leader>ce, <leader>cv, K
#   nvim-lspconfig2  Ctrl-], grr, grn across two files
#   trouble          <leader>ct project-wide diagnostics list
#   conform          <leader>cf format, and undo it
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/nvim-lspconfig.cast \
#       /gifs/instructions/nvim-lspconfig_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/lsp_fixture.sh

MAKE_LSP_FIXTURE

WAIT_NVIM
SETUP "cd $LSP_FIXTURE" "e report.py"

SAY 'nvim-lspconfig connects nvim to language servers that understand your code' 4.0
SAY 'LSP is off by default. <leader>cl starts it for this buffer' 3.5
NV ',cl' 1.0
# pyright: bad argument + undefined name; ruff: undefined name. Both servers
# have to be in before the diagnostics are worth narrating. Fatal on timeout,
# so a server missing from the image fails the take rather than recording an
# empty gutter.
WAIT_LUA 'local b = vim.fn.bufnr("report.py"); local clients = vim.lsp.get_clients({bufnr = b}); local found = {}; for _, c in ipairs(clients) do found[c.name] = true end; return found.pyright and found.ruff and #vim.diagnostic.get(b) >= 3' 60
sleep 1.5

SAY 'pyright and ruff both attached. Problems show in the gutter and at line ends' 4.0
SAY ']d jumps to the next diagnostic, [d to the previous one' 3.0
NV ']d' 1.8
NV ']d' 1.8
NV '[d' 1.8

SAY 'That message is cut off at the edge. <leader>ce shows all of it' 3.5
NV ',ce' 4.5
NV 'j' 1.0

SAY '<leader>cv toggles the inline text, leaving just the signs' 3.5
NV ',cv' 2.0
NV ',cv' 1.5

SETUP "call search('describe(values)')"
SAY 'K shows documentation for the symbol under the cursor' 3.0
NV 'K' 4.0
NV 'j' 1.0

SAY 'Next: jump to definitions, find references, and rename across files' 4.0
NV ':qa!<CR>' 0.5

#!/usr/bin/env bash
# R.nvim, part 2: inspect a data frame, then capture output in the script.
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/r_fixture.sh
MAKE_R_VIEW_FIXTURE
command -v R >/dev/null || {
  echo 'R is not on PATH; rebuild the recording image with R installed in conda base.' >&2
  exit 1
}
command -v vd >/dev/null || {
  echo 'VisiData (vd) is not on PATH; install it in the recording image with ./setup.sh --install-vd.' >&2
  exit 1
}

WAIT_NVIM
# First-run installs can leave lazy.nvim's floating window focused.
WAIT_LUA 'for _, p in pairs(require("lazy.core.config").plugins) do for _, task in ipairs(p._.tasks or {}) do if task:running() then return false end end end; return true' 180
SETUP 'lua local view = require("lazy.view"); if view.visible() then view.view:close() end' \
  "e $R_FIXTURE" 'setlocal number' 'normal! gg'
WAIT_LUA 'return vim.bo.filetype == "r"' 10
WAIT_LUA 'return vim.g.R_Nvim_status == 3' 90
SAY 'R.nvim can inspect data without leaving the editor' 3.0 SW
NV '\rf' 1.5
WAIT_LUA 'return vim.g.R_Nvim_status == 7' 90
NV '<Esc>:wincmd t<CR>' 1.2
WAIT_LUA 'return vim.bo.filetype == "r"' 5
SAY 'gxx previews the built-in mtcars data in R' 3.0 SW
NV '2Ggxx' 2.0
WAIT_TERMINAL_PATTERN 'Mazda RX4'

NV 'gg0' 1.2
SAY '\rv on the name of a dataframe opens it VisiData' 3.0 SW
NV '\rv' 2.0
WAIT_LUA 'return vim.bo.buftype == "terminal" and vim.api.nvim_buf_get_name(0):match("vd") ~= nil' 30
WAIT_TERMINAL_PATTERN 'Mazda RX4'
NV 'jl' 1.5
SAY 'q quits VisiData' 2.5 SW
NV 'q' 1.5
# VisiData exits but leaves its terminal window open; close that window too.
SAY ':q closes the viewer window and returns to the script' 2.5 SW
NV '<C-\><C-n>:q<CR>' 1.2
WAIT_LUA 'return vim.bo.filetype == "r"' 15

NV '3G0' 1.2
SAY '\o runs the expression under the cursor and inserts commented output below it' 3.5 SW
NV '\o' 2.5
WAIT_LUA 'return vim.api.nvim_buf_line_count(0) > 3 and vim.fn.getline(4):match("^%s*#") ~= nil' 20
NV ':qa!<CR>' 0.5

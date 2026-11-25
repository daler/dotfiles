#!/usr/bin/env bash
# R.nvim, part 1: send code and inspect live objects. Requires warmed-up nvimcom.
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/r_fixture.sh
MAKE_R_FIXTURE
command -v R >/dev/null || {
  echo 'R is not on PATH; rebuild the recording image with R installed in conda base.' >&2
  exit 1
}

WAIT_NVIM
# First-run installs can leave lazy.nvim's floating window focused.
WAIT_LUA 'for _, p in pairs(require("lazy.core.config").plugins) do for _, task in ipairs(p._.tasks or {}) do if task:running() then return false end end end; return true' 180
SETUP 'lua local view = require("lazy.view"); if view.visible() then view.view:close() end' \
  "e $R_FIXTURE" 'setlocal number' 'normal! gg'
WAIT_LUA 'return vim.bo.filetype == "r"' 10
WAIT_LUA 'return vim.g.R_Nvim_status == 3' 90

SAY 'R.nvim connects this R script to a live R session' 3.0 SW
SAY '\rf starts R with editor integration' 2.5 SW
NV '\rf' 1.5
WAIT_LUA 'return vim.g.R_Nvim_status == 7' 90
# With the default built-in console layout, the source is the top-left window.
NV '<Esc>:wincmd t<CR>' 1.2
WAIT_LUA 'return vim.bo.filetype == "r"' 5

SAY 'gxx sends just the current line with this configuration' 3.0 SW
NV 'gggxx' 2.0
SAY 'Send counts to print the object in R' 2.5 SW
NV '2Ggxx' 2.0
WAIT_TERMINAL_PATTERN 'control%s+treated'

SAY 'Select two lines; gx sends the selection' 3.0 SW
NV '4GVj' 1.2
NV 'gx' 2.0
WAIT_TERMINAL_PATTERN '%[1%]%s+62'

SAY '\ro opens the live object browser' 2.5 SW
NV '\ro' 3.0
WAIT_LUA 'local b = require("r.browser").get_buf_nr(); return b ~= nil and vim.api.nvim_buf_is_valid(b) and #vim.fn.win_findbuf(b) > 0' 15
NV '/count<CR>'
SAY 'Hit Enter on a object to see it in the interpreter' 2.5 SW
NV '<CR>' 1.2
SAY 'Return to the script and add another measurement' 2.5 SW
NV ',q' 1.2
WAIT_LUA 'return vim.bo.filetype == "r"' 5
NV '7Ggxx' 2.0
NV '8Ggxx' 2.5
WAIT_TERMINAL_PATTERN 'repeat_run'
SAY 'counts now has three values; the browser tracks the R session' 3.0 SW
NV ':qa!<CR>' 0.5

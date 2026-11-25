#!/usr/bin/env bash
# Manual completion: buffer symbols, filesystem paths, and the command line.
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/editing_fixture.sh
MAKE_EDITING_FIXTURE
WAIT_NVIM
SETUP "cd $EDITING_FIXTURE" 'e completion.py' 'normal! G'

SAY 'Blink completion opens on demand in this configuration' 3.0 SW
NV 'i' 1.0
TYPE 'total_' 0.08
SAY 'Tab opens suggestions from names already in this buffer' 3.0 SW
NV '<Tab>' 1.5
WAIT_LUA 'return require("blink.cmp").is_visible()' 10
SAY 'Tab selects the next suggestion; Enter accepts it' 3.0 SW
NV '<Tab>' 1.2
NV '<CR>' 2.0
NV '<Esc>' 1.0
WAIT_LUA 'return vim.fn.getline("$"):match("^total_%a+$") ~= nil' 5

SAY 'The same menu also completes filesystem paths' 3.0 SW
NV 'o' 1.0
TYPE 'path = "./data/rea' 0.08
NV '<Tab>' 1.5
WAIT_LUA 'return require("blink.cmp").is_visible()' 10
NV '<CR>' 1.5
TYPE '"' 0.08
NV '<Esc>' 2.0
WAIT_LUA 'return vim.fn.getline("$"):find("reads.csv", 1, true) ~= nil' 5

SAY 'Command-line completion is manual too: type, then Tab' 3.0 SW
NV ':set numberw' 1.0
NV '<Tab>' 2.0
SAY 'Escape cancels without executing the command' 2.5 SW
NV '<Esc><Esc>' 1.2
NV ':qa!<CR>' 0.5

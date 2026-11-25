#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/treesj_fixture.sh

MAKE_TREESJ_FIXTURE

WAIT_NVIM
SETUP "e $TREESJ_FIXTURE" "call search('report = build_report')"

SAY 'TreeSJ splits and joins syntax nodes' 3.0
SAY '<leader>j splits this long function call across several lines' 3.5
NV ',j' 3.0

SAY 'Press <leader>j again to join the same node' 3.0
NV ',j' 3.0

NV '/^samples =<CR>' 1.2
SAY 'Split the list into one item per line' 3.0
NV ',j' 3.0
SAY 'Toggle it again to return the list to one line' 3.0
NV ',j' 2.5

NV '/^options =<CR>' 1.2
SAY 'Split the dictionary into key-value pairs' 3.0
NV ',j' 2.5
SAY 'Press <leader>j again to join it' 2.5
NV ',j' 2.5

NV ':qa!<CR>' 0.5

#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
WAIT_NVIM
SAY '<leader>fg for live grep within the current directory'
NV ',fg' 1.5
SAY 'here we search for the text "python"'
TYPE 'python' 0.12; sleep 1.5
SAY 'up/down arrows to select different hits'
NV '<Down>' 0.6; NV '<Down>' 0.9;
SAY 'Hit enter to open the corresponding file and jump to the matched line' 3
NV '<CR>' 4
NV ':qa!<CR>'

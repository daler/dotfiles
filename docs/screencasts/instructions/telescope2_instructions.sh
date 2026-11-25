#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
WAIT_NVIM
SAY '<leader>fg for live grep within the current directory' 2.5
NV ',fg' 1.5
SAY 'here we search for the text "python"'
TYPE 'python' 0.12; sleep 1.5
SAY 'up/down arrows to select different hits'
NV '<Down>' 1.2; NV '<Down>' 1.2;
SAY 'Hit enter to open the corresponding file and jump to the matched line' 3
NV '<CR>' 3
NV ':qa!<CR>'

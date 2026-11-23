#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
WAIT_NVIM

SETUP 'e setup.sh'
SAY ',/ to search in the current buffer'
NV ',/' 1.2      # search in current buffer
SAY ',/ to search in the current buffer\n\nhere we search for "conda"' 2
TYPE 'conda' 0.12;
SAY ''
SAY 'Up/down to navigate hits' 2
SAY 'As you navigate hits, the right side panel updates to show the context in the file' 2
NV '<Up>'
NV '<Up>'
NV '<Up>'
NV '<Down>'
SAY 'Enter to jump to that location'
NV '<CR>' 3
NV ':qa!<CR>'
# NV ',' 0.8; NV 'fc' 1.5     # code symbols
# NV '<Down>' 0.5; NV '<Down>' 0.5; NV '<CR>' 2

#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
WAIT_NVIM

SETUP 'e setup.sh'
SAY ',/ to search in the current buffer'
NV ',/' 1.2      # search in current buffer
SAY 'Search for "conda"' 1.5
TYPE 'conda' 0.12; sleep 1.2
SAY 'Up/down to navigate hits' 2
SAY 'The right panel previews the selected hit' 2.5
NV '<Up>' 1.2
NV '<Up>' 1.2
NV '<Up>' 1.2
NV '<Down>' 1.2
SAY 'Enter to jump to that location'
NV '<CR>' 3
NV ':qa!<CR>'

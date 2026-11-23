#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
WAIT_NVIM
SAY 'telescope fuzzy finder: <leader>ff finds files by name, in the current directory' 3.0
NV ',ff' 1.2
SAY 'Search for "setup"'
TYPE 'setu' 0.15; sleep 1.5
SAY 'Hit enter to open the file'
NV '<CR>' 2
NV ',ff'
TYPE 'req'
SAY 'Arrow keys to move within popup' 2
NV '<Down>' 1.5
NV '<CR>' 2
NV ':qa!<CR>' 0.5

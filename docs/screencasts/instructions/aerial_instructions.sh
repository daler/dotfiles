#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/code_outline.sh

MAKE_CODE_OUTLINE

WAIT_NVIM
SETUP "e $CODE_OUTLINE"

SAY 'aerial provides a navigable outline of the current file' 3.5
SAY '<leader>a opens the aerial view on the left' 3.0
NV ',a' 3.0

SAY 'The panel lists classes, methods, and functions for this Python file' 3.5 SW
SAY 'Choose a symbol, then press Enter to jump' 3.0 SW
NV 'jjj' 1.8
NV '<CR>' 2.5

SAY 'Toggle off and on with <leader>a' 3.0 SW
NV ',a' 1.5
NV ',a' 1.5

NV ',w' 1.2
SAY '{ and } jump between code symbols' 3.0
NV '}' 1.5
NV '}' 1.5
NV '{' 1.5
NV '{' 1.5

NV ':qa!<CR>' 0.5

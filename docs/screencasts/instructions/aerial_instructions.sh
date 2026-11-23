#!/usr/bin/env bash
# Cast: aerial -- navigate a file by its code outline. See README.md and NEXT.md.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/aerial.cast \
#       /gifs/instructions/aerial_instructions.sh
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
SAY 'Markdown/ReST files show headers; Snakefiles show rules.' 3.5 SW
SAY 'Navigate like any other buffer, then press Enter to jump to a symbol' 4.0 SW
NV 'jjj' 1.5
NV '<CR>' 2.5


SAY 'Toggle off and on with <leader>a' 3.0 SW
NV ',a' 1.0
NV ',a' 1.0


SAY 'Back in the main buffer, { and } jump directly between symbols' 3.5
NV ',w' 1.8
NV '}' 1.8
NV '}' 1.8
NV '{' 1.8
NV '{' 1.8
NV '{' 1.8

NV ':qa!<CR>' 0.5

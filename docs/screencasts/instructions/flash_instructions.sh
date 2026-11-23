#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/code_outline.sh

MAKE_CODE_OUTLINE

WAIT_NVIM
SETUP "e $CODE_OUTLINE" "normal! gg"

SAY 'flash jumps to visible text while your eyes stay on the destination' 4.0
SAY 'Press s, then type the first two letters of the target' 3.5
NV 's' 1.0
SAY "Let's aim to get to the outputs() method. We can start typing the 'def' part of that line with 'de'..." 2.0
TYPE 'de' 0.18
sleep 2.0

SAY 'Each match gets a one-letter label. Type one to choose the exact destination.' 4.0
SAY 'In this case, q to jump to the outputs() method.'
NV 'q' 2.5

SAY 'The cursor arrives without counting lines or repeating search commands' 4.0
NV ':qa!<CR>' 0.5

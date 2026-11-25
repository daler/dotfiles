#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/code_outline.sh

MAKE_CODE_OUTLINE

WAIT_NVIM
SETUP "e $CODE_OUTLINE" "normal! gg"

SAY 'Flash jumps to labeled matches in visible text' 3.0
SAY "Let's jump to the def outputs() (middle of the screen). Press s ..."
NV 's' 1.0
SAY "Then start typing what you're aiming for (here, 'de')..." 3.0
TYPE 'de' 0.18
SAY 'Labels will appear, and the next key you press will select one' 3.0
SAY "Here 'q' selects the outputs() definition we're looking for." 2.5
NV 'q' 2.5

SAY 'Jump directly—no line counting needed' 2.5
NV ':qa!<CR>' 0.5

#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/code_outline.sh

MAKE_CODE_OUTLINE

WAIT_NVIM
SETUP "e $CODE_OUTLINE" "call search('self.sample_sheet.samples()')"

SAY 'Flash can select treesitter syntax nodes.' 4.0
SAY 'S labels the current syntax node and its parents' 3.0
NV 'S' 3.0
SAY 'j selects the enclosing Workflow class' 3.0
NV 'j' 2.5

NV '<Esc>' 1.0

SAY 'ft jumps to the next t' 2.5
NV 'ft' 2.5

SAY 'Press f again for the next highlighted t' 3.0
NV 'f' 3.0

NV ':qa!<CR>' 0.5

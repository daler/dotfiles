#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/code_outline.sh

MAKE_CODE_OUTLINE

WAIT_NVIM
SETUP "e $CODE_OUTLINE" "call search('self.sample_sheet.samples()')"

SAY 'Flash can select treesitter syntax nodes.' 4.0
SAY 'Press S to label the node under the cursor and each enclosing Treesitter node' 4.0
NV 'S' 3.0
SAY 'In this case, choosing j will select the entire Workflow class in one step' 3.5
NV 'j' 2.5

NV '<Esc>' 1.0

SETUP "call search('Path(destination).write_text')" "normal! 0"
SAY 'Flash also enhances Vim’s f motion: f followed by t jumps to the next t' 4.0
NV 'ft' 3.0

SAY 'The remaining matches stay highlighted; press f again to move to the next one' 4.0
NV 'f' 3.0

SAY 'Treesitter selection with S works by code structure, while f makes short character jumps faster' 4.0
NV ':qa!<CR>' 0.5

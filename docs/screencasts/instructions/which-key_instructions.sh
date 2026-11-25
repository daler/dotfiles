#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh

WAIT_NVIM
SETUP "e setup.sh"

SAY 'which-key helps you discover mappings you have forgotten' 3.5
SAY 'Pause after <leader> to discover mappings' 3.0
NV ',' 2.5

SAY 'f groups file and search commands' 2.5 NE
NV 'f' 2.5

SAY 'Backspace returns to the previous menu' 3.0 NE
NV '<BS>' 2.5
SAY 'Mapping descriptions come from the configuration' 3.0 NE
SAY 'Escape closes which-key without running a command' 3.0 NE
NV '<Esc>' 1.5

NV ':qa!<CR>' 0.5

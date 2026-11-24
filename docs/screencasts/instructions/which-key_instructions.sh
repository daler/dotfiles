#!/usr/bin/env bash
# Cast: which-key -- discover key mappings by prefix. See README.md.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast-which-key --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/which-key.cast \
#       /gifs/instructions/which-key_instructions.sh
set -euo pipefail
source /gifs/lib.sh

WAIT_NVIM
SETUP "e setup.sh"

SAY 'which-key helps you discover mappings you have forgotten' 3.5
SAY 'Press the leader key and pause to see every available prefix' 3.5
NV ',' 2.5

SAY 'Named groups organize related commands—for example, f for files and find' 4.0 NE
NV 'f' 2.5
SAY 'The next menu shows every mapping below that prefix' 3.5 NE

SAY 'Backspace returns to the previous menu' 3.0 NE
NV '<BS>' 2.5
SAY 'Escape closes which-key without running a command' 3.0 NE
NV '<Esc>' 1.5

SAY 'Descriptions come directly from desc fields in the nvim configuration' 4.0
NV ':qa!<CR>' 0.5

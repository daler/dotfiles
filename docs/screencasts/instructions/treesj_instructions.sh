#!/usr/bin/env bash
# Cast: TreeSJ -- split and join a syntax node. See README.md and NEXT.md.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/treesj.cast \
#       /gifs/instructions/treesj_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/treesj_fixture.sh

MAKE_TREESJ_FIXTURE

WAIT_NVIM
SETUP "e $TREESJ_FIXTURE" "call search('report = build_report')"

SAY 'TreeSJ reformats a syntax node without changing what the code does' 4.0
SAY '<leader>j splits this long function call across several lines' 3.5
NV ',j' 3.0

SAY 'The arguments are now easier to scan and edit' 3.0
SAY 'Press <leader>j again to join the same node' 3.0
NV ',j' 3.0

SETUP "call search('samples =')"
SAY 'The same key splits a list, with one item on each line' 3.5
NV ',j' 3.0
SAY 'Toggle it again to return the list to one line' 3.0
NV ',j' 2.5

SETUP "call search('options =')"
SAY 'It understands dictionaries too, keeping each key-value pair together' 3.0
NV ',j' 2.0
NV ',j' 2.5

NV ':qa!<CR>' 0.5

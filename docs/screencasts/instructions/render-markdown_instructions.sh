#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/markdown_fixture.sh

MAKE_MARKDOWN_FIXTURE

WAIT_NVIM
SETUP "e $MARKDOWN_FIXTURE"

SAY 'render-markdown shows a clean reading view by default for Markdown files' 2.0

SAY 'Headings, links, checkboxes, tables, and code blocks gain visual structure' 2.0
NV '7j' 1.5
NV '7j' 1.5

SAY 'Moving around will disable the rendering for that line.' 3.0
NV 'j' 1.0
NV 'j' 1.0
NV 'j' 1.0
NV 'j' 1.0
NV 'j' 1.0

SAY 'Entering insert mode disables all rendering.' 3.0
NV 'i'
NV '<Up>'
NV '<Up>'

SAY 'Normal mode renders again' 2.0
NV '<Esc>'

SAY 'Toggle with <leader>rm' 3.5
NV ',rm' 3.0
NV ',rm' 3.0

NV ':qa!<CR>' 0.5

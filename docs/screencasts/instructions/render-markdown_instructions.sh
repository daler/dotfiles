#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/markdown_fixture.sh

MAKE_MARKDOWN_FIXTURE

WAIT_NVIM
SETUP "e $MARKDOWN_FIXTURE"

SAY 'render-markdown adds a reading view to Markdown' 3.0

SAY 'Links, checkboxes, tables, and code blocks have nice formatting' 3.5
NV '7j' 1.5
NV '7j' 1.5

SAY 'The cursor line shows the Markdown source' 3.0
NV 'j' 1.5
NV 'k' 1.5

SAY 'Entering insert mode disables all rendering.' 3.0
NV 'i' 2.0

SAY 'Normal mode renders again' 2.0
NV '<Esc>' 2.0

SAY 'Toggle with :RenderMarkdown toggle' 3.0
NV ':RenderMarkdown toggle<CR>' 1.2
SAY 'Rendering off' 2.0
NV ':RenderMarkdown toggle<CR>' 1.2
SAY 'Rendering on' 2.0

NV ':qa!<CR>' 0.5

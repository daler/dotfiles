#!/usr/bin/env bash
# Cast: toggleterm -- one embedded terminal, three languages. See README.md.
#
# Story order is deliberate: the mappings are not REPL-specific, so the cast
# proves that with plain bash first (gxx on a line, gx on a selection), then
# reuses the *same* keys against IPython (a whole function, blank line and
# indentation intact), and only then shows the R/RMarkdown-specific ,cd.
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/toggleterm.cast \
#       /gifs/instructions/toggleterm_instructions.sh
set -euo pipefail

# Absolute paths: recorder.sh cd's to /dotfiles before backgrounding this
# script, so a relative `source` dies under `set -e` and nvim is never driven.
source /gifs/lib.sh
source /gifs/setup/toggleterm_fixture.sh

# Prep runs while nvim is still starting up.
MAKE_TOGGLETERM_FIXTURE

WAIT_NVIM
SETUP "let &shell = 'bash --rcfile $TOGGLETERM_RC_FIXTURE'" "e $TOGGLETERM_SH_FIXTURE" 'normal! gg'

# --- bash: the terminal is just a shell -------------------------------------

SAY '<leader>t opens a terminal in a vertical split, ready for input' 3.5 SW
NV ',t' 2.5
SAY ''
WAIT_TERMINAL_PATTERN '#'

SAY 'Use it like any other terminal.' 2.0 SW
TYPE 'echo "just an ordinary shell"' 0.06
NV '<CR>' 1.5
# Anchored: the echoed command line also contains the phrase, after the prompt.
WAIT_TERMINAL_PATTERN '^just an ordinary shell'

SAY '<leader>q hops to the text buffer, <leader>w back to the terminal' 4.0 SW
NV ',q' 2.0

SAY 'gxx sends the line under the cursor -- here a line of bash' 3.5 SW
NV 'gxx' 1.5
WAIT_TERMINAL_PATTERN '^hello from Linux'

SAY 'gx sends a visual selection: the whole loop arrives as one paste' 4.0 SW
NV '3GVjj' 1.5
NV 'gx' 2.0
WAIT_TERMINAL_PATTERN 'value: 42'

# --- python: same keys, an interpreter instead of a shell -------------------

SAY 'Nothing here is tied to a language: start any REPL in that terminal' 4.0 SW
NV ',w' 1.5
TYPE 'ipython' 0.06
NV '<CR>' 0.5
WAIT_TERMINAL_PATTERN '^In %[[0-9]+%]:'

SAY 'The same two mappings now drive IPython' 3.0 SW
NV ',q' 1.5
SETUP "e $TOGGLETERM_PY_FIXTURE" 'normal! gg'
SAY 'gxx on a Python line' 2.5 SW
NV 'gxx' 2.0

SAY 'gx on a whole function: the blank line and the indentation\nboth survive the trip' 4.5 SW
NV '3GVjjj' 1.5
NV 'gx' 2.5

SAY 'The definition is live in that session, so just call it' 3.5 SW
NV '8G' 1.0
NV 'gxx' 1.5
WAIT_TERMINAL_PATTERN 'total=93'

# --- rmarkdown: the one R-specific mapping ---------------------------------

SAY 'Swap IPython for R and the workflow is unchanged' 3.5 SW
NV ',w' 1.5
TYPE 'exit' 0.06
NV '<CR>' 1.5
TYPE 'R --quiet' 0.06
NV '<CR>' 0.5
WAIT_TERMINAL_PATTERN '^> *$'

NV ',q' 1.5
SETUP "e $TOGGLETERM_RMD_FIXTURE" 'normal! ggjjj'
SAY 'In RMarkdown, <leader>cd sends the current chunk and jumps to the next one.' 4.0 SW
NV ',cd' 3.0
# The names row R prints; the echoed assignment has 'control = 20, treated'.
WAIT_TERMINAL_PATTERN 'control%s+treated'

SAY 'So pressing it again runs the next chunk in the same R session\nand since this is the last one, it cycles back to the first one.' 4.0 SW
NV ',cd' 3.0
WAIT_TERMINAL_PATTERN 'total: 62'

SAY ',t to close, or re-open'
NV ',t' 2.0
NV '<Esc>,t' 2.0
WAIT_TERMINAL_PATTERN '^> *$'
SAY 'or quit all with qa!'
NV '<Esc>:qa!<CR>' 0.5

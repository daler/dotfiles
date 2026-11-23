#!/usr/bin/env bash
# Cast: punchlist.nvim -- review notes attached to lines. See README.md and NEXT.md.
#
# Uses the shared demo repo: annotations live in <repo>/.punchlist/, so a git
# repo gives them a stable home. Lines below refer to the *dirty* version of
# scripts/summarize.py that MAKE_DEMO_REPO leaves in the working tree:
#
#    5     for line in open(fn):                         <- DISCUSS note
#    9     config = yaml.safe_load(open("config.yaml"))  <- where it is pasted
#   11-12  if int(count) < ...: continue                 <- FIX note (range)
#
# (each +1 after the shebang line is inserted above them mid-take).
#
#   podman run -v $PWD/docs/screencasts:/gifs --platform linux/amd64 \
#     --name cast --rm -it dotfiles \
#     bash /gifs/recorder.sh /gifs/casts/punchlist.cast \
#       /gifs/instructions/punchlist_instructions.sh
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'punchlist attaches review notes to lines, like comments in a Word document' 4.0
SAY 'The notes are stored outside the file, so the code itself is unchanged' 3.5

SAY '\pd adds a DISCUSS note to the current line' 3.0
NV '5G' 0.8
NV '\pd' 1.5
TYPE 'Should this close the file handle?' 0.05
NV '<CR>' 2.0
SAY 'It shows up as a gutter sign plus virtual text' 3.0

SAY 'Select several lines and \pf adds a FIX note to the whole range' 3.5
NV '11GVj' 1.2
NV '\pf' 1.5
TYPE 'Report how many genes were skipped' 0.05
NV '<CR>' 2.5

SAY 'Notes follow their text as you edit around them' 3.0
NV 'ggO' 0.5
TYPE '#!/usr/bin/env python' 0.05
NV '<Esc>' 2.5

SAY '\px cuts a note, to move it somewhere else...' 3.0
NV '6G' 0.8
NV '\px' 2.0
SAY '...and \pv pastes it onto the current line, after a confirmation' 3.5
NV '10G' 0.8
NV '\pv' 2.5
NV '<CR>' 2.5

SAY '\ps compiles every note into a prompt, with file and line numbers,\nready to paste into an AI agent' 4.5
NV '\ps' 4.0
SAY 'Edit it if you like; y copies it to the clipboard and q closes' 3.5
NV 'q' 2.0

NV ':qa!<CR>' 0.5

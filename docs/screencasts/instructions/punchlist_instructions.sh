#!/usr/bin/env bash
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
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

WAIT_NVIM
SETUP "cd $DEMO_REPO" "e scripts/summarize.py"

SAY 'Punchlist attaches review notes without changing the source text' 3.5

NV '5G' 1.2
SAY '\pd adds a DISCUSS note to the current line' 3.0
NV '\pd' 1.5
TYPE 'Should this close the file handle?' 0.05
NV '<CR>' 2.5

SAY 'Select two lines; \pf adds a FIX note' 3.0
NV '11GVj' 1.2
NV '\pf' 1.5
TYPE 'Report how many genes were skipped' 0.05
NV '<CR>' 2.5

SAY 'Notes follow their text as you edit around them' 2.5
NV 'ggO' 0.5
TYPE '#!/usr/bin/env python' 0.05
NV '<Esc>' 2.5

SAY '\px cuts a note, to move it somewhere else...' 3.0
NV '6G' 1.2
NV '\px' 2.0
SAY '...and \pv pastes it onto the current line, after a confirmation' 3.5
NV '10G' 1.2
NV '\pv' 2.0
NV '<CR>' 2.5

SAY '\ps builds a review prompt with file and line references' 3.5
NV '\ps' 3.0
SAY 'Review the prompt; y copies it, q closes it' 3.0
NV 'q' 2.0

NV ':qa!<CR>' 0.5

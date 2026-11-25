#!/usr/bin/env bash
set -euo pipefail
source /gifs/lib.sh
source /gifs/setup/demo_repo.sh

MAKE_DEMO_REPO

# Match part 2's final index without replaying its UI actions: only the import
# is staged; the filtering changes remain in the working tree.
git -C "$DEMO_REPO" apply --cached <<'PATCH'
diff --git a/scripts/summarize.py b/scripts/summarize.py
--- a/scripts/summarize.py
+++ b/scripts/summarize.py
@@ -1,4 +1,5 @@
 import sys
+import yaml
 
 def load(fn):
     for line in open(fn):
PATCH

WAIT_NVIM
SETUP "cd $DEMO_REPO"
SETUP "e scripts/summarize.py"

SETUP 'tab Git' 'normal gs'

SAY 'Picking up where the last screencast left off:\na few lines of summarize.py are staged' 3.5

SAY "Show what's staged with ="
NV '=' 2
SAY 'cc opens a commit buffer' 2.5
NV 'cc' 2
NV 'i' 1.0

TYPE 'Import yaml package' 0.06
sleep 1
SAY 'Save and close the buffer to make the commit' 3
NV '<Esc>' 0.3
NV ':wq<CR>' 3
NV '<CR>'
NV ':qa!<CR>' 0.5

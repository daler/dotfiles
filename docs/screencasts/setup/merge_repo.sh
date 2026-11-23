# /gifs/setup/merge_repo.sh
# Tiny repository stopped at a two-hunk merge conflict for vim-mergetool.

MERGE_REPO=${MERGE_REPO:-$HOME/merge-demo}

MAKE_MERGE_REPO() {
  rm -rf "$MERGE_REPO"
  mkdir -p "$MERGE_REPO"
  cd "$MERGE_REPO"

  git init -q -b main .
  git config user.name "Demo User"
  git config user.email demo@example.com
  git config commit.gpgsign false
  git config merge.conflictStyle diff3

  cat > report.py <<'PY'
def title(project):
    return f"Report for {project}"


def status(passed):
    return "complete" if passed else "needs review"


print(title("demo"))
print(status(True))
PY
  git add report.py
  git commit -q -m "add report helpers"

  git switch -q -c feature
  sed -i 's/Report for/Summary for/' report.py
  sed -i 's/"complete"/"ready"/' report.py
  git commit -qam "use concise report wording"

  git switch -q main
  sed -i 's/Report for/Results for/' report.py
  sed -i 's/"complete"/"approved"/' report.py
  git commit -qam "use publication wording"

  # The failed merge is the fixture: both wording changes conflict, and diff3
  # markers give vim-mergetool the base revision it requires.
  git merge feature >/dev/null 2>&1 || true
  cd - >/dev/null
}

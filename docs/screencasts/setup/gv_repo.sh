# /gifs/setup/gv_repo.sh
# Compact history with three merged topic branches, designed to make gv's
# commit graph readable at 100 columns.

GV_REPO=${GV_REPO:-$HOME/gv-demo}

MAKE_GV_REPO() {
  rm -rf "$GV_REPO"
  mkdir -p "$GV_REPO/scripts"
  cd "$GV_REPO"

  git init -q -b main .
  git config user.name "Demo User"
  git config user.email demo@example.com
  git config commit.gpgsign false

  cat > README.md <<'EOF'
# expression report

Summarize a two-column count table.
EOF
  cat > scripts/summarize.py <<'PY'
import sys


for line in open(sys.argv[1]):
    gene, count = line.rstrip().split("\t")
    print(gene, count)
PY
  git add -A
  GIT_AUTHOR_DATE='2025-01-01T09:00:00Z' GIT_COMMITTER_DATE='2025-01-01T09:00:00Z' \
    git commit -q -m 'start expression report'

  # First diamond: parser work proceeds while main gains user documentation.
  git switch -q -c feature/parser
  cat > scripts/summarize.py <<'PY'
import sys


def load(path):
    for line in open(path):
        yield line.rstrip().split("\t")


def main(path):
    for gene, count in load(path):
        print(gene, count)


main(sys.argv[1])
PY
  git add scripts/summarize.py
  GIT_AUTHOR_DATE='2025-01-02T09:00:00Z' GIT_COMMITTER_DATE='2025-01-02T09:00:00Z' \
    git commit -q -m 'extract table parser'

  python3 - <<'PY'
from pathlib import Path
p = Path("scripts/summarize.py")
s = p.read_text().replace(
    '    for line in open(path):\n        yield line.rstrip().split("\\t")',
    '    for line in open(path):\n        line = line.rstrip()\n        if line:\n            yield line.split("\\t")',
)
p.write_text(s)
PY
  git add scripts/summarize.py
  GIT_AUTHOR_DATE='2025-01-02T15:00:00Z' GIT_COMMITTER_DATE='2025-01-02T15:00:00Z' \
    git commit -q -m 'ignore blank input rows'

  git switch -q main
  cat >> README.md <<'EOF'

## Usage

    python scripts/summarize.py counts.tsv
EOF
  git add README.md
  GIT_AUTHOR_DATE='2025-01-03T09:00:00Z' GIT_COMMITTER_DATE='2025-01-03T09:00:00Z' \
    git commit -q -m 'document command line usage'
  GIT_AUTHOR_DATE='2025-01-04T09:00:00Z' GIT_COMMITTER_DATE='2025-01-04T09:00:00Z' \
    git merge -q --no-ff feature/parser -m 'merge parser branch'

  # Second diamond: filtering changes the script while workflow configuration
  # changes independently on main, keeping the merge deliberately clean.
  git switch -q -c feature/filter
  cat > config.yaml <<'EOF'
min_count: 10
EOF
  python3 - <<'PY'
from pathlib import Path
p = Path("scripts/summarize.py")
s = p.read_text().replace(
    "    for gene, count in load(path):\n        print(gene, count)",
    "    for gene, count in load(path):\n        if int(count) >= 10:\n            print(gene, count)",
)
p.write_text(s)
PY
  git add config.yaml scripts/summarize.py
  GIT_AUTHOR_DATE='2025-01-05T09:00:00Z' GIT_COMMITTER_DATE='2025-01-05T09:00:00Z' \
    git commit -q -m 'filter low expression counts'

  sed -i 's/min_count: 10/min_count: 12/' config.yaml
  sed -i 's/int(count) >= 10/int(count) >= 12/' scripts/summarize.py
  git add config.yaml scripts/summarize.py
  GIT_AUTHOR_DATE='2025-01-05T15:00:00Z' GIT_COMMITTER_DATE='2025-01-05T15:00:00Z' \
    git commit -q -m 'tune minimum count threshold'

  git switch -q main
  cat > Snakefile <<'EOF'
rule summarize:
    input: "counts.tsv"
    output: "summary.tsv"
    shell: "python scripts/summarize.py {input} > {output}"
EOF
  git add Snakefile
  GIT_AUTHOR_DATE='2025-01-06T09:00:00Z' GIT_COMMITTER_DATE='2025-01-06T09:00:00Z' \
    git commit -q -m 'add summary workflow rule'
  GIT_AUTHOR_DATE='2025-01-07T09:00:00Z' GIT_COMMITTER_DATE='2025-01-07T09:00:00Z' \
    git merge -q --no-ff feature/filter -m 'merge filtering branch'

  # Third diamond gives the graph another lane and revisits a line in main(),
  # making visual line history more interesting than a single commit.
  git switch -q -c feature/format-output
  sed -i 's/print(gene, count)/print(f"{gene}\\t{count}")/' scripts/summarize.py
  git add scripts/summarize.py
  GIT_AUTHOR_DATE='2025-01-08T09:00:00Z' GIT_COMMITTER_DATE='2025-01-08T09:00:00Z' \
    git commit -q -m 'emit tab-separated output'

  python3 - <<'PY'
from pathlib import Path
p = Path("scripts/summarize.py")
s = p.read_text().replace(
    '\n\ndef main(path):',
    '\n\ndef format_row(gene, count):\n    return f"{gene}\\t{count}"\n\n\ndef main(path):',
).replace('print(f"{gene}\\t{count}")', 'print(format_row(gene, count))')
p.write_text(s)
PY
  git add scripts/summarize.py
  GIT_AUTHOR_DATE='2025-01-08T15:00:00Z' GIT_COMMITTER_DATE='2025-01-08T15:00:00Z' \
    git commit -q -m 'extract row formatter'

  git switch -q main
  cat >> README.md <<'EOF'

Output is a tab-separated table suitable for downstream rules.
EOF
  git add README.md
  GIT_AUTHOR_DATE='2025-01-09T09:00:00Z' GIT_COMMITTER_DATE='2025-01-09T09:00:00Z' \
    git commit -q -m 'describe report output'
  GIT_AUTHOR_DATE='2025-01-10T09:00:00Z' GIT_COMMITTER_DATE='2025-01-10T09:00:00Z' \
    git merge -q --no-ff feature/format-output -m 'merge output branch'

  cd - >/dev/null
}

# /gifs/demo_repo.sh
#
# Shared prep for the git-related casts (vim-fugitive, diffview).
#
# The container's /dotfiles is ADDed, not cloned, so there is no git repo to
# demo with -- and even if there were, its history is far too noisy to read at
# cast resolution. So build a tiny throwaway repo with a handful of commits and
# a dirty working tree, and point nvim at that instead.
#
# Call MAKE_DEMO_REPO *before* WAIT_NVIM: it only touches the filesystem, so it
# can run while nvim is still starting up, and both fugitive and diffview
# discover the repo lazily when their commands are first run.

DEMO_REPO=${DEMO_REPO:-$HOME/demo}

MAKE_DEMO_REPO() {
  rm -rf "$DEMO_REPO"
  mkdir -p "$DEMO_REPO/scripts"
  cd "$DEMO_REPO"

  # Identity has to be repo-*local*: the image's ~/.gitconfig sets no user, and
  # fugitive's cc runs git from inside nvim, so exported GIT_AUTHOR_* env vars
  # here would not reach it.
  git init -q -b main .
  git config user.name "Demo User"
  git config user.email demo@example.com
  git config commit.gpgsign false

  # --- commit 1 ------------------------------------------------------------
  cat > README.md <<'EOF'
# demo project

A small example workflow.

## Usage

    snakemake -j 4
EOF

  cat > Snakefile <<'EOF'
rule all:
    input: "results/summary.tsv"

rule summarize:
    input: "data/counts.tsv"
    output: "results/summary.tsv"
    shell: "python scripts/summarize.py {input} > {output}"
EOF
  git add -A
  git commit -q -m "initial workflow skeleton"

  # --- commit 2 ------------------------------------------------------------
  cat > scripts/summarize.py <<'EOF'
import sys

def load(fn):
    for line in open(fn):
        yield line.strip().split("\t")

def main():
    for gene, count in load(sys.argv[1]):
        print(gene, count)

main()
EOF

  cat > config.yaml <<'EOF'
threads: 4
min_count: 0
EOF
  git add -A
  git commit -q -m "add summarize script and config"

  # --- commit 3 ------------------------------------------------------------
  sed -i 's/^min_count: 0$/min_count: 10/' config.yaml
  cat >> README.md <<'EOF'

Configuration lives in `config.yaml`.
EOF
  git add -A
  git commit -q -m "raise default min_count to 10"

  # --- dirty working tree, for fugitive/diffview to show -------------------
  # Two separate hunks in one file, plus a second modified file and an
  # untracked file, so the status buffer has something in every section.
  cat > scripts/summarize.py <<'EOF'
import sys
import yaml

def load(fn):
    for line in open(fn):
        yield line.strip().split("\t")

def main():
    config = yaml.safe_load(open("config.yaml"))
    for gene, count in load(sys.argv[1]):
        if int(count) < config["min_count"]:
            continue
        print(gene, count)

main()
EOF

  cat >> README.md <<'EOF'

Counts below `min_count` are dropped.
EOF

  cat > notes.md <<'EOF'
TODO: add a rule for plotting.
EOF

  cd - >/dev/null
}

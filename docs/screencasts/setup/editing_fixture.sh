# Small, independent files for editing casts; no network or language server.
EDITING_FIXTURE=${EDITING_FIXTURE:-$HOME/editing_cast_demo}

MAKE_EDITING_FIXTURE() {
  mkdir -p "$EDITING_FIXTURE/data"
  printf 'group,reads\ncontrol,20\ntreated,42\n' > "$EDITING_FIXTURE/data/reads.csv"
  cat > "$EDITING_FIXTURE/completion.py" <<'PY'
total_count = 62
total_reads = 93

PY
  cat > "$EDITING_FIXTURE/selection.py" <<'PY'
def summarize(values):
    return sum([value * 2 for value in values])
PY
  cat > "$EDITING_FIXTURE/surround.py" <<'PY'
label = control
PY
  cat > "$EDITING_FIXTURE/comments.py" <<'PY'
counts = [20, 42]
total = sum(counts)
print(total)
PY
  # Real tabs: the cast selects screen columns with a fixed tabstop of 12.
  printf 'sample\tgroup\tnote\ns1\told\told\ns2\told\told\ns3\told\told\n' > "$EDITING_FIXTURE/columns.tsv"
}

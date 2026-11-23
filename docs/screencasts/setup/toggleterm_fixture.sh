# /gifs/setup/toggleterm_fixture.sh
# Three tiny files -- bash, Python, RMarkdown -- for the toggleterm cast. They
# are deliberately narrow: the terminal takes half of a 100-column window, so
# both the sent code and its output have to fit in ~50 columns.
#
# Line numbers matter, because the driver navigates by absolute line
# (`3GVjj`, `8G`). Keep the layout below in sync with
# instructions/toggleterm_instructions.sh if you edit these.

TOGGLETERM_SH_FIXTURE=${TOGGLETERM_SH_FIXTURE:-$HOME/terminal_demo.sh}
TOGGLETERM_RC_FIXTURE=${TOGGLETERM_RC_FIXTURE:-$HOME/terminal_demo.bashrc}
TOGGLETERM_PY_FIXTURE=${TOGGLETERM_PY_FIXTURE:-$HOME/terminal_demo.py}
TOGGLETERM_RMD_FIXTURE=${TOGGLETERM_RMD_FIXTURE:-$HOME/terminal_demo.Rmd}

MAKE_TOGGLETERM_FIXTURE() {
  # ToggleTerm starts a separate interactive shell; activating conda in this
  # driver would not affect it. Source the normal bashrc first so `ca` exists.
  cat > "$TOGGLETERM_RC_FIXTURE" <<'RC'
source ~/.bashrc
ca
RC

  # 1: gxx target (prints something, so the send is visible)
  # 3-5: gx target -- a multi-line block, which only runs because
  #      toggleterm's exec() sends a newline after the closing bracketed-paste
  #      escape; bash itself would otherwise leave the paste on the prompt.
  cat > "$TOGGLETERM_SH_FIXTURE" <<'SH'
printf 'hello from %s\n' "$(uname -s)"

for n in 20 42; do
    echo "value: $n"
done
SH

  # 1: gxx target, 3-6: gx target (a whole function *including a blank line*,
  # which is the interesting case -- a naive line-by-line send would end the
  # block early in IPython), 8: gxx target that calls it.
  cat > "$TOGGLETERM_PY_FIXTURE" <<'PY'
values = [20, 42, 31]

def summarize(items):
    total = sum(items)

    return f"n={len(items)} total={total}"

print(summarize(values))
PY

  cat > "$TOGGLETERM_RMD_FIXTURE" <<'RMD'
# A language-agnostic REPL workflow

```{r}
counts <- c(control = 20, treated = 42)
counts
```

```{r}
total <- sum(counts)
sprintf("total: %d", total)
```
RMD
}

# /gifs/setup/lsp_fixture.sh
# A two-file Python project for the nvim-lspconfig, trouble, and conform casts.
#
# Every problem is planted on purpose, one per kind of diagnostic, so each
# server has something to say:
#
#   stats.py:1   `import os` is unused                       (ruff F401)
#   report.py:9  mean(samples)    passes a dict, not floats   (pyright)
#   report.py:10 `totl` is undefined                          (ruff F821)
#
# `mean` is defined in stats.py and used in both files, so rename/references
# have something to cross. SAMPLES in report.py is deliberately badly spaced
# for conform to fix.
#
# Line numbers matter: the drivers navigate with `call search(...)` where they
# can, but the diagnostic counts passed to WAIT_LUA assume exactly the problems
# above. Keep instructions/{nvim-lspconfig*,trouble,conform}_instructions.sh in
# sync if you edit these.

LSP_FIXTURE=${LSP_FIXTURE:-$HOME/lspdemo}

MAKE_LSP_FIXTURE() {
  rm -rf "$LSP_FIXTURE"
  mkdir -p "$LSP_FIXTURE"

  # Root marker for pyright (see root_markers in plugins/nvim-lspconfig.lua);
  # without one the servers attach in single-file mode and cross-file
  # references/rename do not work.
  cat > "$LSP_FIXTURE/pyproject.toml" <<'TOML'
[project]
name = "lspdemo"
version = "0.1.0"
TOML

  cat > "$LSP_FIXTURE/stats.py" <<'PY'
import os
from typing import Iterable


def mean(values: Iterable[float]) -> float:
    """Arithmetic mean of a sequence of numbers."""
    values = list(values)
    return sum(values) / len(values)


def describe(values: list[float]) -> str:
    """One-line summary of a group of measurements."""
    return f"n={len(values)} mean={mean(values):.2f}"
PY

  cat > "$LSP_FIXTURE/report.py" <<'PY'
from stats import describe, mean

SAMPLES = {"control":[20.0,22.5],   "treated" : [41.0,43.5]}


def report(samples: dict[str, list[float]]) -> None:
    for name, values in samples.items():
        print(name, describe(values))
    print("overall:", mean(samples))
    print(totl)


report(SAMPLES)
PY
}

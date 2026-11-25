# /gifs/setup/treesj_fixture.sh
# Compact Python fixture with a function call, list, and dictionary for TreeSJ.

TREESJ_FIXTURE=${TREESJ_FIXTURE:-$HOME/treesj_demo.py}

MAKE_TREESJ_FIXTURE() {
  cat > "$TREESJ_FIXTURE" <<'PY'
from pathlib import Path


def build_report(samples, output_dir, include_metadata=True, compress_results=False):
    return {
        "samples": samples,
        "output_dir": output_dir,
        "include_metadata": include_metadata,
        "compress_results": compress_results,
    }


report = build_report(["control", "treated"], Path("results"), include_metadata=True, compress_results=False)

samples = ["control", "treated", "baseline", "follow_up"]
options = {"include_metadata": True, "compress_results": False, "format": "parquet"}
PY
}

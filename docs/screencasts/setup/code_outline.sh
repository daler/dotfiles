# /gifs/setup/code_outline.sh
# Small Python fixture with enough nested symbols to make Aerial useful.

CODE_OUTLINE=${CODE_OUTLINE:-$HOME/code_outline.py}

MAKE_CODE_OUTLINE() {
  cat > "$CODE_OUTLINE" <<'PY'
from pathlib import Path


class SampleSheet:
    def __init__(self, filename):
        self.filename = Path(filename)

    def samples(self):
        for line in self.filename.read_text().splitlines():
            if line and not line.startswith("#"):
                yield line.split("\t")[0]


class Workflow:
    def __init__(self, sample_sheet):
        self.sample_sheet = sample_sheet

    def inputs(self):
        return [f"reads/{sample}.fastq" for sample in self.sample_sheet.samples()]

    def outputs(self):
        return [f"results/{sample}.txt" for sample in self.sample_sheet.samples()]

    def run(self):
        for source, destination in zip(self.inputs(), self.outputs()):
            summarize(source, destination)


def summarize(source, destination):
    text = Path(source).read_text()
    Path(destination).write_text(text.upper())


def main():
    sheet = SampleSheet("samples.tsv")
    Workflow(sheet).run()


if __name__ == "__main__":
    main()
PY
}

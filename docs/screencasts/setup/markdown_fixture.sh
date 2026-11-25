# /gifs/setup/markdown_fixture.sh
# RMarkdown fixture showing the elements enhanced by render-markdown.nvim.

MARKDOWN_FIXTURE=${MARKDOWN_FIXTURE:-$HOME/analysis_plan.md}

MAKE_MARKDOWN_FIXTURE() {
  cat > "$MARKDOWN_FIXTURE" <<'MD'
# Analysis plan

Compare the [project notes](notes/design.md) with the [published protocol](https://example.org/protocol).

## Checklist

- [x] Validate sample names
- [ ] Run the analysis
- [ ] Review the report

## Samples

| Group | Replicates | Status |
|-------|------------|--------|
| Control | 3 | Ready |
| Treated | 3 | Pending |

## Example

```python
for sample in samples:
    summarize(sample)
```
MD
}

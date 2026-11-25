# /gifs/setup/table_fixture.sh
# Markdown file for the vim-table-mode cast: some CSV to :Tableize, and an
# empty last line to type a new table on.
#
# Line numbers matter, because the driver navigates by absolute line (`5GV3j`,
# `G`). Keep instructions/vim-table-mode_instructions.sh in sync if you edit.
#
#   5-8  CSV block (header + 3 rows)
#   11   empty line where the new table is typed

TABLE_FIXTURE=${TABLE_FIXTURE:-$HOME/tables.md}

MAKE_TABLE_FIXTURE() {
  cat > "$TABLE_FIXTURE" <<'MD'
# Results

Raw counts, as exported from the spreadsheet:

sample,condition,reads
s1,control,1204
s2,treated,987
s10,treated,15022

Summary:

MD
}

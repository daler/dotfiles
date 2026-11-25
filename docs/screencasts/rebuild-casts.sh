
FAST_RECORD=1
MIN_DWELL=0.1

function record {
  (
    cd ../../ && \
    podman run -v "$PWD/docs/screencasts:/gifs" \
    --platform linux/amd64 \
    -e FAST_RECORD="${FAST_RECORD:-0}" \
    -e MIN_DWELL="${MIN_DWELL:-0.1}" \
    -e KEEP_MARKS="${KEEP_MARKS:-0}" \
    -e WAIT_SHOW="${WAIT_SHOW:-0.5}" \
    --name "cast-$1" \
    --rm \
    -it dotfiles \
    bash /gifs/recorder.sh "/gifs/casts/${1}.cast" "/gifs/instructions/${1}_instructions.sh";
  ) || return $?
  m=${2:-"0"}
  if [[ $# -ge 3 ]]; then
    ./timing.py --trim-start "marker:$m" --trim-end "marker:$3" --in-place "casts/$1.cast"
  else
    ./timing.py --trim-start "marker:$m" --in-place "casts/$1.cast"
  fi
}

# Usage:
#
# record <name> [start marker to trim to] [end marker to trim to]

# record telescope
# record telescope2
# record telescope3
# record vim-fugitive
# record vim-fugitive2
# record vim-fugitive3
# record vim-fugitive4
# record diffview
# record diffview2
# record gitsigns
# record gitsigns2
# record gitsigns3
# record which-key
# record aerial
# record treesj
# record render-markdown
# record flash
# record flash2
# record gv
# record vim-mergetool
# record toggleterm
# record toggleterm2
# record toggleterm3
# record nvim-lspconfig
# record nvim-lspconfig2
# record trouble
# record conform
# record punchlist
# record vim-table-mode
# record r-nvim
# record r-nvim2
# record blink
# record treesitter
# record vim-surround
# record vim-commentary
# record vis

return {
  { "vim-scripts/vis" }, -- restrict replacement only to visual selection
  { "chrisbra/vim-diff-enhanced" }, -- provides other diff algorithms
  { "roxma/vim-tmux-clipboard" }, -- clipboard works better with tmux
  { "dhruvasagar/vim-table-mode" }, -- easily work with ReST and Markdown tables
  { "tpope/vim-commentary" }, -- toggle comments
  { "tpope/vim-surround" }, -- text objects for surrounding characters
  { "tpope/vim-sleuth" }, -- autodetect indentation settings
  { "tpope/vim-fugitive", cmd = "Git", lazy = true }, -- convenient git interface, with incremental commits
  { "junegunn/gv.vim", cmd = "GV", dependencies = { "tpope/vim-fugitive" }, lazy = true }, -- graphical git log
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } }, -- nice diff interface
  { "daler/zenburn.nvim", lazy = false, priority = 1000, branch = "markdown-improvements" }, -- colorscheme
  { "morhetz/gruvbox", enabled = false }, -- example of an alternative colorscheme, here disabled
  { "joshdick/onedark.vim", lazy = false }, -- another colorscheme, here enabled as a fallback for terminals with no true-color support like Terminal.app.
  { "norcalli/nvim-colorizer.lua", config = true, lazy = true, cmd = "ColorizerToggle" }, -- color hex codes by their actual color
}

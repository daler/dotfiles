-- gv.vim provides a graphical git log
return {
  {
    "junegunn/gv.vim",
    cmd = "GV",
    dependencies = { "tpope/vim-fugitive" }
  },
}

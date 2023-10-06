require("zenburn")
vim.cmd("set termguicolors")
vim.cmd("colorscheme zenburn")

-- Some hints for tweaking colorschemes:
--    Use :Inspect to see what highlight group the cursor is over.
--    Use :Telescope higlight to search for it and find the current setting

if vim.api.nvim_exec("colorscheme", true) == "zenburn.nvim" then
  -- The following are some tweaks to the zenburn colorscheme.

  -- Make the line numbers a little more obvious than the default.
  vim.cmd("highlight LineNr guifg=#959898 guibg=#353535")
  vim.cmd("highlight CursorLineNr guifg=#f2f48d guibg=#2f2f2f")

  -- Use the original zenburn's incremental search highlight
  vim.cmd("highlight IncSearch guifg=#f8f893 guibg=#385f38")

  -- Use italics for comments (may be difficult to get working under tmux)
  vim.cmd("highlight Comment cterm=italic gui=italic")

  -- Brighter diff delete, for better visibility in gitsigns
  vim.cmd("highlight DiffDelete guifg=#9f8888 guibg=#464646")

  vim.cmd("highlight Identifier guifg=#dcdccc")
  vim.cmd("highlight Constant guifg=#dcdccc gui=bold")
  vim.cmd("highlight Boolean guifg=#FFCFAF gui=bold")
  vim.cmd("highlight Function guifg=#f6f6ab")

  vim.cmd("highlight @punctuation.bracket.bash guifg=#FFCFAF")
  vim.cmd("highlight @punctuation.special.bash guifg=#FFCFAF")
  vim.cmd("highlight @constant.bash guifg=#FFCFAF")
  vim.cmd("highlight @variable.bash guifg=#FFCFAF")

  --
  vim.cmd("highlight IblScope guifg=#efefaf")
  vim.cmd("highlight @ibl.scope.char.1 guifg=#efefaf")
end

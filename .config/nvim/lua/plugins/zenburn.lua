return {
  -- Main colorscheme
  "phha/zenburn.nvim",

  -- Main colorscheme should not lazy-load and be high-priority, as per lazy.nvim docs
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme zenburn")
    vim.cmd("set termguicolors")

    -- Make the line numbers a little more obvious than the default.
    vim.cmd("highlight LineNr guifg=#959898 guibg=#353535")
    vim.cmd("highlight CursorLineNr guifg=#f2f48d guibg=#2f2f2f")

    -- Use the original zenburn's incremental search highlight
    vim.cmd("highlight IncSearch guifg=#f8f893 guibg=#385f38")

    -- Use italics for comments
    vim.cmd("highlight Comment cterm=italic gui=italic")

    -- Brighter diff delete, for better visibility in gitsigns
    vim.cmd("highlight DiffDelete guifg=#9f8888 guibg=#464646")
  end,
}

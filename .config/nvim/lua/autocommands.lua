-- <leader>d inserts a header for today's date. Different commands depending on
-- the format of the filetype (ReStructured Text or Markdown)
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "rst",
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<leader>d",
      '<Esc>:r! date "+\\%Y-\\%m-\\%d"<CR>A<CR>----------<CR>',
      { desc = "Insert date as section title" }
    )
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<leader>d",
      '<Esc>:r! date "+\\# \\%Y-\\%m-\\%d"<CR>A',
      { desc = "Insert date as section title" }
    )
  end,
})

-- Always use insert mode when entering a terminal buffer, even with mouse click.
-- NOTE: Clicking with a mouse a second time enters visual select mode, just like in a text buffer.
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.cmd("if &buftype == 'terminal' | startinsert | endif")
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
})

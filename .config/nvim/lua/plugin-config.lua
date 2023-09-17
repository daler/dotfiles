-- Lua code for additional nvim configuration

-- Some Lua packages need to have their setup() function run.
require('leap').set_default_keymaps()

-- Override the ToggleTerm setting for vertical split terminal
require('toggleterm').setup{
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end
}

-- Highlight when yanking text
-- ---------------------------
-- This flashes a highlight color over the yanked text, see
-- :help vim.highlight.on_yank()
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

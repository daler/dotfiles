-- treesj splits and joins nodes
return {
  'Wansmer/treesj',
  keys = {'<leader>j'},
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
    vim.keymap.set('n', '<leader>j', require('treesj').toggle, { desc = "Toggle split/join nodes" })
  end,
}

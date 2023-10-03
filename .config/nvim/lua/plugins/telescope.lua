return  {
    'nvim-telescope/telescope.nvim',
    config = function()

      vim.keymap.set('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer=false})<CR>",
        { desc = "Find files"})

      vim.keymap.set('n', '<leader>fg', "<cmd>Telescope live_grep<cr>",
        { desc = "Live grep in directory" })

      vim.keymap.set('n', '<leader>/', "<cmd>Telescope current_buffer_fuzzy_find<cr>",
        { desc = "Fuzzy find in buffer"})
    end,
}

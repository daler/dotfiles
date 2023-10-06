return {
  "danilamihailov/beacon.nvim",
  config = function()
    vim.keymap.set("n", "<S-k><S-j>", ":Beacon<CR>", { desc = "Flash beacon" })
    vim.keymap.set("n", "N", "N:Beacon<CR>")
    vim.keymap.set("n", "n", "n:Beacon<CR>")
    vim.keymap.set("n", "%", "%:Beacon<CR>")
    vim.keymap.set("n", "*", "*:Beacon<CR>")
    vim.cmd("highlight Beacon guibg=white ctermbg=15")
    vim.cmd("let g:beacon_show_jumps=0")
  end,
}

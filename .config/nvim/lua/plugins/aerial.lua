return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("aerial").setup()
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Prev code symbol" })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next code symbol" })
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>", { buffer = bufnr, desc = "Toggle aerial nav" })
  end,
}

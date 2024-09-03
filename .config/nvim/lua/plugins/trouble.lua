-- split window to show issues found by LSP
return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ct", "<cmd>TroubleToggle<CR>", desc = "Toggle trouble.nvim" },
    },
  },
}

-- trouble splits window to show issues found by LSP
return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    { "<leader>ct", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)", },
  },
}

return {
  "daler/punchlist.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("punchlist").setup({})
  end,
}

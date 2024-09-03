-- code (or document) navigation with an "aerial view"
return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = { layout = { default_direction = "prefer_left" } },
    keys = {
      { "{", "<cmd>AerialPrev<CR>", desc = "Prev code symbol" },
      { "}", "<cmd>AerialNext<CR>", desc = "Next code symbol" },
      { "<leader>a", "<cmd>AerialToggle<CR>", desc = "Toggle [a]erial nav" },
    },
  },
}

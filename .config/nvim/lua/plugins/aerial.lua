-- navigation with an "aerial view" on the left side
return {
  {
    "stevearc/aerial.nvim",
    branch="nvim-0.11",
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

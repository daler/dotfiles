-- neo-tree provides a file navigation tree
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  -- don't lazy load; otherwise, opening a directory as first buffer doesn't trigger it.
  lazy = false,
  keys = {
    { "<leader>fb", "<cmd>Neotree toggle<CR>", desc = "[f]ile [b]rowser toggle" },
  },
}

-- file browser
return {
  {
    "nvim-tree/nvim-tree.lua",
    -- otherwise, opening a directory as first buffer doesn't trigger it.
    lazy = false,
    config = true,
    keys = {
      { "<leader>fb", "<cmd>NvimTreeToggle<CR>", desc = "[f]ile [b]rowser toggle" },
    },
  },
}

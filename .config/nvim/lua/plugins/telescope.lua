-- pop-up window used for fuzzy-searching and selecting
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    keys = {
      {
        "<leader>ff",
        function()
          -- use a previewer that doesn't show each file's contents
          local previewer = require("telescope.themes").get_dropdown({ previewer = false })
          require("telescope.builtin").find_files(previewer)
        end,
        desc = "[f]ind [f]iles",
      },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "[f]ind with [g]rep in directory" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
      { "<leader>fc", "<cmd>Telescope treesitter<CR>", desc = "[f]ind [c]ode object" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "[f]ind [r]ecently-opened files" },
    },
  },
}

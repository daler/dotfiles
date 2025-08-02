-- nvim-aider allows you to work closely with aider (command-line AI assistant)
return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  keys = {
    { "<leader>A/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
    { "<leader>As", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
    { "<leader>Ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
    { "<leader>Ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
    { "<leader>A+", "<cmd>Aider add<cr>", desc = "Add File" },
    { "<leader>A-", "<cmd>Aider drop<cr>", desc = "Drop File" },
    { "<leader>Ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
    { "<leader>AR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
    { "<leader>A+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
    { "<leader>A-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
  },
  dependencies = {
    "folke/snacks.nvim",
    "nvim-tree/nvim-tree.lua",
    {
      "nvim-neo-tree/neo-tree.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      tag = "3.33",
      opts = function(_, opts)
        require("nvim_aider.neo_tree").setup(opts)
      end,
    },
  },
  config = {
    -- this removes all built-in arguments (--stream --pretty
    -- --no-auto-commits) and instead defers to ~/.aider.config.yml. So you
    -- should store your config there.
    args = {},

    -- uses zenburn colors. Note: these are converted to args for aider to use,
    -- e.g. user_input_color is sent as --user-input-color
    theme = {
      user_input_color = "#f0efd0",
      tool_output_color = "#8c8cbc",
      tool_error_color = "#e89393",
      tool_warning_color = "#f0dfaf",
      assistant_output_color = "#dcdccc",
      completion_menu_color = "#cad3f5",
      completion_menu_bg_color = "#24273a",
      completion_menu_current_color = "#181926",
      completion_menu_current_bg_color = "#f4dbd6",
    },
    win = {
      position = "bottom"
    },
  },
}

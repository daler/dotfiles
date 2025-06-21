return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  -- Example key mappings for common actions:
  keys = {
    { "<leader>A/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
    { "<leader>As", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
    { "<leader>Ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
    { "<leader>Ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
    { "<leader>A+", "<cmd>Aider add<cr>", desc = "Add File" },
    { "<leader>A-", "<cmd>Aider drop<cr>", desc = "Drop File" },
    { "<leader>Ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
    { "<leader>AR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
    -- Example nvim-tree.lua integration if needed
    { "<leader>A+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
    { "<leader>A-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
  },
  dependencies = {
    "folke/snacks.nvim",
    --- The below dependencies are optional
    "catppuccin/nvim",
    "nvim-tree/nvim-tree.lua",
    {
      "nvim-neo-tree/neo-tree.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      },
      tag = "3.33",
      opts = function(_, opts)
        -- Example mapping configuration (already set by default)
        -- opts.window = {
        --   mappings = {
        --     ["+"] = { "nvim_aider_add", desc = "add to aider" },
        --     ["-"] = { "nvim_aider_drop", desc = "drop from aider" }
        --     ["="] = { "nvim_aider_add_read_only", desc = "add read-only to aider" }
        --   }
        -- }
        require("nvim_aider.neo_tree").setup(opts)
      end,
    },
  },
  config = {
    -- this removes all built-in arguments (--stream --pretty
    -- --no-auto-commits) and instead defers to ~/.aider.config.yml. So you
    -- should store your config there.
    args = {},

    -- uses zenburn colors. Note: these converted to args for aider to use, like --user-input-color
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
  },
}

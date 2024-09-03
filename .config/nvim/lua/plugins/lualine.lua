-- status line along the bottom
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "linrongbin16/lsp-progress.nvim",
    },
    opts = {
      options = { theme = "zenburn" },
      sections = {
        lualine_c = { { "filename", path = 2 } },
        -- use lsp-progress plugin to show LSP activity
        lualine_x = {
          function()
            return require("lsp-progress").progress()
          end,
        },
      },
    },
  },
}

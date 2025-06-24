return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },

  -- using a release tag downloads pre-built binaries
  version = "v1.4.1",
  opts = {
    keymap = { preset = "super-tab" },

    completion = {
      trigger = {
        -- recommended setting when using preset = "super-tab"
        show_in_snippet = false,
      },

      -- disable automatic addition of parentheses when using LSP
      accept = { auto_brackets = { enabled = false } },

      -- Constant menu popping up was annoying to me; disabling it means you need to
      -- use <C-space> to explicitly open the tab completion menu
      menu = { auto_show = false },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}

-- blink.cmp provides autocompletion
return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },

  -- using a release tag downloads pre-built binaries
  version = "v1.4.1",

  opts = {
    keymap = { preset = "super-tab" },

    completion = {
      menu = { enabled = true, auto_show = false },
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  opts_extend = { "sources.default" },
}

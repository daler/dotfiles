return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },

  -- use a release tag to download pre-built binaries
  version = "v1.4.1",
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = "super-tab" },

    completion = {
      trigger = {
        -- recommended setting when using preset = "super-tab"
        show_in_snippet = false,
      },

      -- disable automatic addition of parentheses when using LSP
      accept = { auto_brackets = { enabled = false } },

      -- Constant menu popping up was annoying; disabling it means you need to
      -- use <C-space> to open
      menu = { auto_show = false },
    },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly
    -- better performance You may use a lua implementation instead by using
    -- `implementation = "lua"` or fallback to the lua implementation, when the
    -- Rust fuzzy matcher is not available, by using `implementation
    -- = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}

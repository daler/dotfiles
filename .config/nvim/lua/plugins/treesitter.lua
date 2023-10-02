return {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    cmd = { "TSUpdateSync" },
    keys = {
      { "<C-space", desc = "Increment selection" },
      { "<BS>", desc= "Decrement selection", mode = "x" },
    },
    opts = {
      highlight = { enable = false },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "html",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "vim",
        "yaml",
        "r",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
    },

    config = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          ---@type table<string, boolean>
          local added = {}
          opts.ensure_installed = vim.tbl_filter(function(lang)
            if added[lang] then
              return false
            end
            added[lang] = true
            return true
          end, opts.ensure_installed)
        end
        require("nvim-treesitter.configs").setup(opts)

        if load_textobjects then
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                local Loader = require("lazy.core.loader")
                Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
                local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
                require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
                break
              end
            end
          end
        end
      end,
}

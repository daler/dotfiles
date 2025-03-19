-- treesitter provides sophisticated syntax highlighting and code inspection
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,

          -- Disable markdown indentation because it prevents bulleted lists
          -- from wrapping correctly with `gq`.
          disable = { "markdown" },
        },
        -- --------------------------------------------------------------------
        -- CONFIGURE ADDITIONAL PARSERS HERE
        -- These will be attempted to be installed automatically, but you'll
        -- need a C compiler installed.
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "html",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "r",
          "rnoweb",
          "rst",
          "snakemake",
          "vim",
          "vimdoc",
          "yaml",
        },

        -- Starting from the current line, use Tab or Shift-Tab to increase or
        -- decrease the selection depending on scope.
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>cs",
            node_incremental = "<Tab>",
            scope_incremental = false,
            node_decremental = "<S-Tab>",
          },
        },

        -- Support selecting objects based on parser. E.g., vaf to visually
        -- select a function, or cip to change inside a parameter. More can be
        -- added, see
        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = { query = "@function.outer", desc = "Select function (outer)" },
              ["if"] = { query = "@function.inner", desc = "Select function (inner)" },
              ["ap"] = { query = "@parameter.outer", desc = "Select parameter (outer)" },
              ["ip"] = { query = "@parameter.inner", desc = "Select parameter (inner)" },
            },

            -- use the entire line V) or just characters (v (default)) when
            -- selecting
            selection_modes = {
              ["@parameter.inner"] = "v", -- charwise
              ["@parameter.outer"] = "v", -- charwise
              ["@function.inner"] = "V", -- linewise
              ["@function.outer"] = "V", -- linewise
              ["@class.inner"] = "V", -- linewise
              ["@class.outer"] = "V", -- linewise
              ["@scope"] = "v",
            },
          },
        },
      })
      vim.cmd("set foldmethod=expr")
      vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
      vim.cmd("set nofoldenable")

      -- RMarkdown doesn't have a good treesitter parser, but Markdown does
      vim.treesitter.language.register("markdown", "rmd")
      vim.treesitter.language.register("markdown", "rmarkdown")
    end,
  },
}

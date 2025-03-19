-- treesitter provides sophisticated syntax highlighting and code inspection
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
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

return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "html",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "perl",
        "python",
        "vim",
        "yaml",
        "r",
        "rst",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "<Tab>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
    })
    vim.cmd("set foldmethod=expr")
    vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
    vim.cmd("set nofoldenable")
  end,
}

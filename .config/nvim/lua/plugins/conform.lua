-- conform runs code through a formatter
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Run buffer through formatter",
      },
    },
    opts = {
      -- If you make changes here, you'll probably want to update the lists in
      -- `mason.lua` as well so they get installed. Otherwise, run :Mason and
      -- use the interface to install manually.
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff", "black" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
        ["yaml.ansible"] = { "ansible-lint" },
        snakemake = { "snakefmt" },
        markdown = { "markdownlint" },
        rmd = { "prettier", "injected" },
        r = { "air" },
        rst = {"rstfmt"},
        yaml = { "yamlfmt" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        prettier = { prepend_args = { "--parser", "markdown" } },
      },
    },
  },
}

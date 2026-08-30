-- treesitter provides sophisticated syntax highlighting and code inspection


-- List the parsers here that you want to have installed.
--
-- Recent versions of treesitter do not install by default. These can be
-- installed with:
--
--   :lua require("nvim-treesitter").install(require("plugins.treesitter")[1].opts.parsers)
--

local parsers = {
  "bash",
  "css",
  "dockerfile",
  "hcl",
  "html",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "vim",
  "vimdoc",
  "yaml",
  "r",
  "rst",
  "snakemake",
}

local configured_parsers = {}
for _, parser in ipairs(parsers) do
  configured_parsers[parser] = true
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = { "williamboman/mason.nvim" },
    opts = { parsers = parsers },
    config = function()
      require("nvim-treesitter").setup()

      -- RMarkdown doesn't have a dedicated parser, but Markdown does.
      vim.treesitter.language.register("markdown", "rmd")
      vim.treesitter.language.register("markdown", "rmarkdown")

      -- The main branch no longer auto-enables highlighting or indentation, so
      -- start Treesitter explicitly for filetypes whose parsers we manage here.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          local language = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
          if not configured_parsers[language] then
            return
          end

          vim.treesitter.start()

          -- Markdown indentation interferes with wrapping bulleted lists.
          if language ~= "markdown" then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldenable = false

      -- Preserve the previous incremental-selection mappings using Nvim 0.12's
      -- built-in Treesitter selection API.
      vim.keymap.set("n", "<leader>cs", function()
        vim.treesitter.select("parent")
      end, { desc = "Start Treesitter selection" })
      vim.keymap.set("x", "<Tab>", function()
        vim.treesitter.select("parent")
      end, { desc = "Expand Treesitter selection" })
      vim.keymap.set("x", "<S-Tab>", function()
        vim.treesitter.select("child")
      end, { desc = "Shrink Treesitter selection" })
    end,
  },
}

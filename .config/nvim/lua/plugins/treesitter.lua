-- Treesitter provides sophisticated syntax highlighting and code inspection.

-- Recent versions of nvim-treesitter do not install parsers automatically.
-- Add or remove languages in the list below, then run:
--
--   :TSInstallConfigured

-- Parsers to install
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
  "perl",
  "yaml",
  "r",
  "rst",
  "snakemake",
}

local configured_parsers = {}
for _, parser in ipairs(parsers) do
  configured_parsers[parser] = true
end

-- Check only parsers installed in nvim-treesitter's managed directory.
local function warn_unconfigured(installed)
  local extra = {}
  for _, lang in ipairs(installed) do
    if not configured_parsers[lang] then
      extra[#extra + 1] = lang
    end
  end
  if #extra > 0 then
    table.sort(extra)
    vim.notify(
      "Treesitter parsers installed but not listed in plugins/treesitter.lua:\n"
        .. table.concat(extra, "\n")
        .. "\nAdd these parsers to the parsers table in plugins/treesitter.lua,"
        .. " or remove them with :TSUninstall if no longer needed.",
      vim.log.levels.WARN
    )
  end
end

-- Install missing parsers, update outdated ones, and check that they all are
-- present.
local function install_parsers()
  return pcall(function()
    local ts = require("nvim-treesitter")
    warn_unconfigured(ts.get_installed("parsers"))
    print(("Installing %d parsers: %s"):format(#parsers, table.concat(parsers, " ")))

    local exe = vim.fn.exepath("tree-sitter")
    assert(exe ~= "", "the tree-sitter CLI is not on Nvim's PATH")
    local check = vim.system({ exe, "--version" }, { text = true }):wait()
    assert(check.code == 0, "the tree-sitter CLI at " .. exe .. " does not run: " .. (check.stderr or ""))
    print("Using " .. vim.trim(check.stdout) .. " at " .. exe)

    ts.install(parsers, { summary = true }):wait(900000)
    ts.update(parsers, { summary = true }):wait(900000)

    local installed = {}
    for _, lang in ipairs(ts.get_installed("parsers")) do
      installed[lang] = true
    end
    local missing = vim.tbl_filter(function(lang)
      return not installed[lang]
    end, parsers)
    assert(#missing == 0, "Configured parsers missing: " .. table.concat(missing, " "))
    print("All configured Treesitter parsers installed")
  end)
end

vim.api.nvim_create_user_command("TSInstallConfigured", function()
  local ok, err = install_parsers()
  if not ok then
    vim.notify("Treesitter parser installation failed: " .. tostring(err), vim.log.levels.ERROR)

    -- detect if running headless; exit the headless process nonzero if errors
    if #vim.api.nvim_list_uis() == 0 then
      vim.cmd("cquit 1")
    end
  end
end, { desc = "Install/update the Treesitter parsers listed in plugins/treesitter.lua" })

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
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

          local parser_available, parser_error = vim.treesitter.language.add(language)
          if not parser_available then
            vim.notify_once(
              string.format("Treesitter parser unavailable for %s: %s", language, parser_error or "unknown error"),
              vim.log.levels.WARN
            )
            return
          end

          vim.treesitter.start(0, language)

          -- window-local config
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldenable = false

          -- Markdown and ReST indentation interferes with wrapping bulleted lists.
          if language ~= "markdown" and language ~= "rst" then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

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

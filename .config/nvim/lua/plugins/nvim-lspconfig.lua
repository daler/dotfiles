-- nvim-lspconfig allows convenient configuration of LSP clients
return {
  "neovim/nvim-lspconfig",
  config = function()

    vim.lsp.config("pyright", {
      cmd = { "pyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
      },
    })

    vim.lsp.config("ruff", {
      init_options = {
        settings = {
          lint = { preview = true },
        },
      },
    })

    vim.lsp.config("bashls", {
      cmd = { "bash-language-server", "start" },
      filetypes = { "sh", "bash" },
      root_markers = { ".git" },
    })

    vim.lsp.config("r_language_server", {
      cmd = { "R", "--slave", "-e", "languageserver::run()" },
      filetypes = { "r", "rmd" },
      root_markers = { ".git", "DESCRIPTION" },
    })

    vim.lsp.config("ansible", {
      cmd = { "ansible-language-server", "--stdio" },
      filetypes = { "yaml.ansible" },
    })

    vim.lsp.config("lua_ls", {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            library = { vim.env.VIMRUNTIME },
          },
        },
      },
    })

    vim.diagnostic.config({ virtual_text = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        vim.keymap.set("n", "<leader>cv", function()
          local current_config = vim.diagnostic.config()
          vim.diagnostic.config({
            virtual_text = not current_config.virtual_text,
          })
        end, { buf = ev.buf, desc = "Toggle diagnostic virtual text" })
        vim.keymap.set(
          "n",
          "<leader>ce",
          vim.diagnostic.open_float,
          { buf = ev.buf, desc = "Open diagnostics/errors" }
        )
      end,
    })
  end,
  keys = {
    {
      "<leader>cl",
      function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients > 0 then
          vim.cmd("LspStop")
        else
          vim.cmd("LspStart")
        end
      end,
      desc = "Toggle LSP",
    },
  },
}

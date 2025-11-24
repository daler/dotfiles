-- nvim-lspconfig allows convenient configuration of LSP clients

-- nvim 0.11 changed the way lspconfig works, so we split the config based on
-- version (hence the duplication)
local post_v011 = vim.version().minor >= 11

if post_v011 then
  return {
    "neovim/nvim-lspconfig",
    version = "v2.5",
    config = function()
      -- Python language server
      vim.lsp.config.pyright = {
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
      }

      -- Bash language server
      vim.lsp.config.bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_markers = { ".git" },
      }

      -- R language server
      vim.lsp.config.r_language_server = {
        cmd = { "R", "--slave", "-e", "languageserver::run()" },
        filetypes = { "r", "rmd" },
        root_markers = { ".git", "DESCRIPTION" },
      }

      -- Lua language server
      vim.lsp.config.lua_ls = {
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
      }

      -- By default show the virtual text.
      vim.diagnostic.config({ virtual_text = true })

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "<leader>cv", function()
            local current_config = vim.diagnostic.config()
            vim.diagnostic.config({
              virtual_text = not current_config.virtual_text,
            })
          end, { buffer = ev.buf, desc = "Toggle diagnostic virtual text" })
          vim.keymap.set(
            "n",
            "<leader>ce",
            vim.diagnostic.open_float,
            { buffer = ev.buf, desc = "Open diagnostics/errors" }
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
else
  return {
    "neovim/nvim-lspconfig",
    version = "v2.5",
    init = function()
      local lspconfig = require("lspconfig")

      -- below, autostart = false means that you need to explicity call :lspstart (<leader>cl)
      --
      -- ----------------------------------------------------------------------
      -- configure additional language servers here
      --
      -- pyright is the language server for python
      lspconfig.pyright.setup({ autostart = false })

      lspconfig.bashls.setup({ autostart = false })

      -- language server for r
      lspconfig.r_language_server.setup({ autostart = false })

      -- language server for lua. these are the recommended options
      -- when mainly using lua for neovim
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      })

      -- use lspattach autocommand to only map the following keys after
      -- the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("lspattach", {
        group = vim.api.nvim_create_augroup("userlspconfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "<leader>cgd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Goto Definition" })
          vim.keymap.set("n", "<leader>ck", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover help" })
          vim.keymap.set("n", "<leader>crn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
          vim.keymap.set("n", "<leader>cgr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Goto References" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code Action" })
        end,
      })
    end,
    keys = {
      -- because autostart=false above, need to manually start the language server.
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
      { "<leader>ce", vim.diagnostic.open_float, desc = "Open diagnostics/errors" },
      { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic/error" },
      { "[d", vim.diagnostic.goto_prev, desc = "Prev diagnostic/error" },
    },
  }
end

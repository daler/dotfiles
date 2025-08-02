-- language server protocol support.
--
-- nvim 0.11 has lots of built-in support, so use that if we can
if vim.fn.has('nvim-0.11') == 1 then
  return {
    {
      "williamboman/mason.nvim",
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
      },
      keys = {
        {
          "<leader>cl",
          function()
            local running_lsp_config = vim.lsp.get_clients()
            if next(running_lsp_config) == nil then
              vim.cmd("LspStart")
            else
              vim.cmd("LspStop")
            end
          end,
          desc = "Toggle LSP"
        },
      },
      opts = {
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = {
                  globals = { 'vim', 'require' },
                },
                workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                },
              },
            },
          },

          pyright = {},
          bashls = {},
        },
      },
      config = function(_, opts)
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "pyright", "bashls" },
        })
        for server, config in pairs(opts.servers) do
          vim.lsp.config(server, config)
          -- By default, we need to intentionally start the LSP with <leader>cl, but if you want to run it as soon as a file is opened, then uncomment this line.
          -- vim.lsp.enable(server, true)
        end

        -- Set up an autocmd to only set the following keymaps if we have attached an LSP (LspAttach event)
        vim.api.nvim_create_autocmd(
          "LspAttach",
          {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
              vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>
              local opts2 = { buffer = ev.buf }

              -- Run code thru formatter
              vim.keymap.set("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, opts2)

              -- Open the diagnostic under the cursor in a float window
              vim.keymap.set("n", "<leader>d", function()
                vim.diagnostic.open_float({ border = "rounded", })

                -- Toggle virtual lines for diagnostics everywhere in buffer
                vim.keymap.set('n', 'gK', function()
                  local new_config = not vim.diagnostic.config().virtual_lines
                  vim.diagnostic.config({ virtual_lines = new_config })
                end, { desc = 'Toggle diagnostic virtual_lines' })
              end, opts2)
            end,
          }
        )
      end,
    },
  }
else
  -- nvim <0.11 support (will be removed eventually)
  return {
    {
      "neovim/nvim-lspconfig",
      dependencies = { "saghen/blink.cmp" },
      cmd = "LspStart",
      init = function()
        local lspconfig = require("lspconfig")

        -- Below, autostart = false means that you need to explicity call :LspStart (<leader>cl)
        --
        -- ----------------------------------------------------------------------
        -- CONFIGURE ADDITIONAL LANGUAGE SERVERS HERE
        opts = {
          servers = {
            pyright = { autostart = false },
            bashls = { autostart = false },
            lua_ls = {
              autostart = false,
              -- These are the recommended options when mainly using Lua for
              -- Neovim
              on_init = function(client)
                local path = client.workspace_folders[1].name
                if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                  client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                    Lua = {
                      runtime = { version = "LuaJIT" },
                      workspace = {
                        checkThirdParty = false,
                        library = {
                          vim.env.VIMRUNTIME,
                        },
                      },
                    },
                  })

                  client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                end
              end,
            },
          },
        }

        for server, config in pairs(opts.servers) do
          config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
          lspconfig[server].setup(config)
        end

        -- Use LspAttach autocommand to only map the following keys after
        -- the language server attaches to the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = function(ev)
            vim.keymap.set("n", "<leader>cgd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Goto definition" })
            vim.keymap.set("n", "<leader>cK", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover help" })
            vim.keymap.set("n", "<leader>crn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
            vim.keymap.set("n", "<leader>cgr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Goto references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
          end,
        })
      end,
      keys = {
        -- Because autostart=false above, need to manually start the language server.
        { "<leader>cl", "<cmd>LspStart<CR>",       desc = "Start LSP" },
        { "<leader>ce", vim.diagnostic.open_float, desc = "Open diagnostics/errors" },
        { "]d",         vim.diagnostic.goto_next,  desc = "Next diagnostic/error" },
        { "[d",         vim.diagnostic.goto_prev,  desc = "Prev diagnostic/error" },
      },
    },
  }
end

-- nvim-lspconfig allows convenient configuration of LSP clients
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

      local lspconfig = require("lspconfig")
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
      { "<leader>cl", "<cmd>LspStart<CR>", desc = "Start LSP" },
      { "<leader>ce", vim.diagnostic.open_float, desc = "Open diagnostics/errors" },
      { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic/error" },
      { "[d", vim.diagnostic.goto_prev, desc = "Prev diagnostic/error" },
    },
  },
}

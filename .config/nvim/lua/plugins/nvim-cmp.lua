return {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "f3fora/cmp-spell",
    },
    -- The following is from the nvim-cmp wiki, which shows how to configure
    -- similar to SuperTab. That is, the window only appears when you hit tab,
    -- and replaces the text you're writing.
    config = function()

      require("luasnip.loaders.from_vscode").lazy_load()

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require('cmp')

      cmp.setup {
        -- even if you don't use snippets, nvim-cmp needs a snippets plugin configured.
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },

      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
        -- they way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      },

      -- Prevent the window from appearing unless you hit TAB.
      completion = {
        autocomplete = false,
      },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          {
              name = 'spell',
              option = {
                  keep_all_entries = false,
                  enable_in_context = function()
                      return true
                  end,
              },
          },
        }),
      }
    end,
}

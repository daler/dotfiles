
-- Lua code for additional nvim configuration
--
-- Welcome to the Lua config. Neovim can be configured with Lua, a complete programming language.

-- plugin: mason.nvim-----------------------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup()
require('lint').linters_by_ft = {
    python = {'flake8',}
}
-- plugin: leap-----------------------------------------------------------------
require('leap').set_default_keymaps()

-- plugin: toggleterm ----------------------------------------------------------
require('toggleterm').setup{
-- Override the ToggleTerm setting for vertical split terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end
}

-- Highlight when yanking text--------------------------------------------------
-- This custom function flashes a highlight color over the yanked text, see
-- :help vim.highlight.on_yank()
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- plugin: treesitter-----------------------------------------------------------
-- Location to store the installed parsers, also configured for nvim-treesitter below.
vim.opt.runtimepath:append("$HOME/opt/parsers")

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "python", "r", "lua"},
  auto_install = false,

  -- set to the above path appended to the runtimepath.
  parser_install_dir = "$HOME/opt/parsers",

  -- Disable highlight (it highlights too much for my taste)
  highlight = { enable = false, },

  -- Incremental selection allows selecting ever-larger pieces of the file
  -- (expression, line, loop, function, class, etc).
  -- <Enter> when in normal mode to start selection
  -- <TAB> to grow the selection
  -- <Shift-TAB> to shrink the selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
}


-- plugin: lspconfig------------------------------------------------------------

-- Abstract out some common args
local opts = { noremap=true, silent=true }
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', '<space>K', vim.lsp.buf.signature_help, opts)
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- plugin: lspconfig, pyright-----------------------------------------------------------------
-- Python language server. Here's one way to install (assuming ~/opt/bin is on your PATH):
-- mamba create -n pyright pyright -y && ln -s $CONDA_PREFIX/envs/pyright/bin/pyright ~/opt/bin/pyright
require('lspconfig')['pyright'].setup{
    capabilities = capabilities,
}

-- plugin: lspconfig, marksman----------------------------------------------------------------
-- Markdown language server. Not currently in conda, but you can install with a pre-built binary
-- https://github.com/artempyanykh/marksman/blob/main/docs/install.md#option-2-use-pre-built-binary
require('lspconfig')['marksman'].setup{
    capabilities = capabilities,
}

-- plugin: lspconfig, rlanguageserver---------------------------------------------------------
-- R language server. It needs both the rlanguageserver as well as a version of R to run.
-- mamba create -n rlanguageserver r-rlangaugeserver -y
-- ln -s $CONDA_PREFIX/envs/rlanguageserver/bin/rlanguageserver ~/opt/bin
-- ln -s $CONDA_PREFIX/envs/rlanguageserver/bin/R ~/opt/bin/R_for_rlanguageserver
require'lspconfig'.r_language_server.setup{
    capabilities = capabilities,
    -- cmd = { "$HOME/opt/bin/R_for_rlanguageserver", "--slave", "-e", "languageserver::run()" },
}

-- plugin: lspconfig, lua_ls------------------------------------------------------------------
-- Lua language server. Download tarball from https://github.com/LuaLS/lua-language-server/releases/tag/3.7.0
-- Extract tte tarball somewhere, and add its bin/ directory to your PATH.
-- Note that the executable needs the files in the tarbal, so you can't just symlink it to ~/opt/bin.
--
-- The following sets it up for use with developing Lua code for nvim. Super useful if you're working on this very file.
require('lspconfig')['lua_ls'].setup {
  capabilities = capabilities,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            version = 'LuaJIT'
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
            }
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}

-- plugin: indent_blankline-----------------------------------------------------
require("indent_blankline").setup {
    show_current_context = true, -- Make the vertical line brighter for the context you're in
    show_current_context_start = true, -- With treesitter installed, underlines the first line of the context
    char = '┊', -- make the character a little less dense
}

-- plugin: which-key------------------------------------------------------------
-- Be sure to try registers ("), marks ('), and spelling (z=).
--
-- Backspace to go back a level, e.g., to see top-level built-in keys.
--
-- This gives a 1-sec pause before opening the menu (tweak as needed)
vim.o.timeout = true
vim.o.timeoutlen = 1000

require('which-key').setup{}

local wk = require("which-key")
wk.register({
    g = {
        q = "Re-wrap",
        x = "Send selection to terminal",

    },
},  { mode="v"} )
wk.register({
  ['gq'] = {"Re-wrap", mode="v"},
  ['gx'] = "Send selection to terminal",
  ['<leader>k'] = "[k]nit RMarkdown",
  ['<leader>cd'] = "Send RMarkdown chunk to R",
  ['<leader>yr'] = "Insert YAML frontmatter for .Rmd",
  ['<leader>`'] = "Insert RMarkdown chunk",
  ['<leader>1'] = 'Previous buffer',
  ['<leader>2'] = 'Next buffer',
  ['<leader>b'] = 'Switch to buffer (tab-complete)',
  ['<leader><Tab>'] = 'Configure for TSV files (leaves cursor in command)',
  ['<leader>H'] = 'Toggle highlight search',
  ['<leader>i'] = 'Toggle vert. indent lines',
  ['<leader>t'] = 'New terminal buffer to the right',
  ['<leader>w'] = 'Cursor to right window, enter insert mode',
  ['<leader>q'] = 'Cursor to left window, enter normal mode',
  ['<leader>-'] = 'Fill line with "-" out to 80 cols',
  ['<leader>r'] = 'Toggle relative line numbering',
  ['<leader>R'] = 'Refresh syntax highlighting',
  ['b]'] = 'Next buffer',
  ['[b'] = 'Previous Gbuffer',
})


-- plugin: telescope
require('telescope').setup { }


wk.register({
  f = {
    name = "file", -- optional group name
    f = { "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer=false})<CR>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, }, -- additional options for creating the keymap
    b = { "<cmd>Telescope buffers<cr>", "Switch to buffer"},
    g = { "<cmd>Telescope live_grep<cr>", "Live grep in directory" },
  },
}, { prefix = "<leader>" })

wk.register({
    ['<leader>/'] = {"<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find in buffer"}
})

-- plugin: nvim-cmp

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')

cmp.setup {
  -- even if you 
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),

  -- Disable the autocompletion on every. Single. Keystroke. Only enable upon hitting <TAB>.
  completion = {
      autocomplete = false,
  }
}

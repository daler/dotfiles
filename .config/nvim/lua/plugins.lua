-- Returns a table of plugin specs for lazy.nvim to handle. They will be
-- automatically installed when starting nvim.
--
-- See https://daler.github.io/dotfiles/vim.html#plugins for descriptions and
-- keymappings...or read on.
--
-- In general, plugins are lazy-loaded if possible. Loading can be triggered by
-- commands, filetypes, or keymappings. Many plugins have keymappings, and
-- along with the description these are picked up by which-key.
--
return {
  { "vim-scripts/vis" }, -- restrict replacement only to visual selection
  { "chrisbra/vim-diff-enhanced" }, -- provides other diff algorithms
  { "roxma/vim-tmux-clipboard" }, -- clipboard works better with tmux
  { "dhruvasagar/vim-table-mode" }, -- easily work with ReST and Markdown tables
  { "tpope/vim-commentary" }, -- toggle comments
  { "tpope/vim-surround" }, -- text objects for surrounding characters
  { "tpope/vim-sleuth" }, -- autodetect indentation settings
  { "Vimjas/vim-python-pep8-indent", ft = { "python", "snakemake" } }, -- better indentation for python
  { "samoshkin/vim-mergetool", cmd = "MergetoolStart" }, -- easily work with 3-way merge conflicts
  { "tpope/vim-fugitive", cmd = "Git", lazy = true }, -- convenient git interface, with incremental commits
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } }, -- nice diff interface
  { "stsewd/sphinx.nvim", ft = "rst" }, -- syntax/grammar for Sphinx (ReST) documentation
  { "folke/which-key.nvim", lazy = false, config = true }, -- pop up a window showing possible keybindings
  { "phha/zenburn.nvim", lazy = false, priority = 1000 }, -- colorscheme
  { "EdenEast/nightfox.nvim", lazy = false, priority = 1000,
    config = function ()
      require('nightfox').setup({
        options = {
          styles = { comments = "italic", },
        },
      })
    end,
  },
  { "morhetz/gruvbox", enabled = false }, -- example of an alternative colorscheme, here disabled

  {
    "nvim-tree/nvim-tree.lua", -- file browser
    config = function()
      require("nvim-tree").setup({
        disable_netrw = false,
        hijack_netrw = true,
      })
    end,
    keys = {
      { "<leader>fbc", "<cmd>NvimTreeClose<CR>", desc = "[f]ile [b]rowser [c]lose (nvim-tree)" },
      { "<leader>fbo", "<cmd>NvimTreeFocus<CR>", desc = "[f]ile [b]rowser [o]pen (or focus if open)" },
    },
  },

  {
    "vim-pandoc/vim-pandoc-syntax", -- improves editing markdown and ReST
    ft = { "markdown", "rmarkdown" },
    dependencies = { "vim-pandoc/vim-pandoc" },
  },

  {
    "vim-pandoc/vim-rmarkdown", -- improves editing RMarkdown
    ft = "rmarkdown",
    dependencies = { "vim-pandoc/vim-pandoc-syntax", "vim-pandoc/vim-pandoc" },
  },

  {
    "nvim-telescope/telescope.nvim", -- pop-up window used for fuzzy-searching and selecting
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    keys = {
      {
        "<leader>ff",
        function()
          local previewer = require("telescope.themes").get_dropdown({ previewer = false })
          require("telescope.builtin").find_files(previewer)
        end,
        desc = "Find files",
      },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep in directory" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
      { "<leader>fc", "<cmd>Telescope treesitter<CR>", desc = "Find code object" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Find recently-opened files" },
    },
  },

  {
    "danilamihailov/beacon.nvim", -- flash a beacon to show where you are
    lazy = false, -- otherwise, on first KJ you get a double-flash
    keys = {
      { "<S-k><S-j>", ":Beacon<CR>", desc = "Flash beacon" },
      { "N", "N:Beacon<CR>", desc = "Prev search hit and flash beacon" },
      { "n", "n:Beacon<CR>", desc = "Next search hit and flash beacon" },
      { "%", "%:Beacon<CR>", desc = "Go to matching bracket and flash beacon" },
      { "*", "*:Beacon<CR>", desc = "Go to next word occurrence and flash beacon" },
    },
  },

  {
    "rhysd/accelerated-jk", -- speeds up vertical navigation
    keys = {
      { "j", "<Plug>(accelerated_jk_gj)" },
      { "k", "<Plug>(accelerated_jk_gk)" },
    },
    config = function()
      -- see :help accelerated_jk_acceleration_table
      vim.cmd("let g:accelerated_jk_acceleration_table = [7, 13, 20, 33, 53, 86]")
    end,
  },

  {
    "vim-pandoc/vim-pandoc", -- improves editing markdown and RMarkdown
    lazy = true,
    init = function()
      vim.cmd("let g:pandoc#syntax#conceal#use = 0") -- " Disable the conversion of ``` to lambda and other fancy concealment/conversion that ends up confusing me
      vim.cmd("let g:pandoc#folding#fold_fenced_codeblocks = 1") -- " RMarkdown code blocks can be folded too
      vim.cmd("let g:pandoc#spell#enabled = 0") -- " By default, keep spell-check off. Turn on with `set spell`
      vim.cmd("let g:pandoc#keyboard#display_motions = 0") -- Disable remapping j to gj and k to gk
    end,
  },

  {
    "akinsho/toggleterm.nvim", -- terminal in vim you can send code to
    lazy = false,
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.5
          end
        end,
      })
      -- Always use insert mode when entering a terminal buffer, even with mouse
      -- click. NOTE: Clicking with a mouse a second time enters visual select mode,
      -- just like in a text buffer.
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          vim.cmd("if &buftype == 'terminal' | startinsert | endif")
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rmarkdown",
        callback = function()
          vim.keymap.set(
            "n",
            "<leader>k",
            ":TermExec cmd='rmarkdown::render(\"%:p\")'<CR>",
            { desc = "Render RMarkdown to HTML" }
          )
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.keymap.set("n", "<leader>k", ":TermExec cmd='run %:p'<CR>", { desc = "Run Python file in IPython" })
        end,
      })
    end,
    keys = {
      { "gxx", ":ToggleTermSendCurrentLine<CR><CR>", desc = "Send current line to terminal" },
      { "gx", ":ToggleTermSendVisualSelection<CR><CR>", desc = "Send selection to terminal", mode = "x" },
      {
        "<leader>cd",
        "/```{r<CR>NjV/```<CR>k<Esc>:ToggleTermSendVisualSelection<CR>/```{r<CR>",
        desc = "Send RMarkdown chunk to R",
      },
      { "<leader>t", ":ToggleTerm direction=vertical<CR>", desc = "New terminal on right" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter", -- sophisticated syntax highlighting and code inspection
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = { "markdown", "rmarkdown" }, -- let pandoc handle highlighting for these
        },
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
          "snakemake",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>cs",
            node_incremental = "<Tab>",
            scope_incremental = false,
            node_decremental = "<S-Tab>",
          },
        },
      })
      vim.cmd("set foldmethod=expr")
      vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
      vim.cmd("set nofoldenable")

      -- RMarkdown doesn't have a good treesitter parser, but Markdown does
      vim.treesitter.language.register("markdown", "rmd")
      vim.treesitter.language.register("markdown", "rmarkdown")
    end,
  },

  {
    "ggandor/leap.nvim", -- quickly jump around the buffer without counting lines
    config = function()
      require("leap").set_default_keymaps()
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim", -- show vertical lines at tabstops
    lazy = false,
    main = "ibl",
    opts = {
      indent = { char = "┊" }, -- make the character a little less dense
      scope = { exclude = { language = { "markdown", "rst" } } },
    },
  },

  {
    "stevearc/aerial.nvim", -- code navigator
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },

    opts = { layout = { default_direction = "prefer_left" } },
    keys = {
      { "{", "<cmd>AerialPrev<CR>", buffer = bufnr, desc = "Prev code symbol" },
      { "}", "<cmd>AerialNext<CR>", buffer = bufnr, desc = "Next code symbol" },
      { "<leader>a", "<cmd>AerialToggle<CR>", buffer = bufnr, desc = "Toggle aerial nav" },
    },
  },

  {
    "lewis6991/gitsigns.nvim", -- show changes in git repo
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    "vim-airline/vim-airline", -- status line along the bottom
    dependencies = { "vim-airline/vim-airline-themes" },
    init = function()
      vim.cmd("let g:airline_theme='ayu_dark'") -- theme that looks good with zenburn
      vim.cmd("let g:airline_powerline_fonts = 1") -- use powerline fonts; set to 0 if you don't have them installed
      vim.cmd("let g:airline_extensions = ['tabline']") -- use the tabline extension
      vim.cmd("let g:airline#extensions#tabline#enabled = 1")
      vim.cmd("let g:airline#extensions#tabline#fnamemod = ':t'") -- just show the basename of the open file
      -- vim.cmd("let g:airline#extensions#tabline#buffer_nr_show = 1") -- Show a buffer number for easier switching
    end,
  },

  {
    "L3MON4D3/LuaSnip", -- allow tab completion of snippets
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
      keys = {
        {
          "<tab>",
          function()
            return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
          end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "<tab>",
          function()
            require("luasnip").jump(1)
          end,
          mode = "s",
        },
        {
          "<s-tab>",
          function()
            require("luasnip").jump(-1)
          end,
          mode = { "i", "s" },
        },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp", -- tab completion
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    event = "InsertEnter",
    opts = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")
      return {
        completion = { autocomplete = false },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
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
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
}

-- vim: nowrap
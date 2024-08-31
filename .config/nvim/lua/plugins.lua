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
  { "daler/vim-python-pep8-indent", ft = { "python", "snakemake" } }, -- better indentation for python
  { "samoshkin/vim-mergetool", cmd = "MergetoolStart" }, -- easily work with 3-way merge conflicts
  { "tpope/vim-fugitive", cmd = "Git", lazy = true }, -- convenient git interface, with incremental commits
  { "junegunn/gv.vim", cmd = "GV", dependencies = { "tpope/vim-fugitive" }, lazy = true }, -- graphical git log
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } }, -- nice diff interface
  { "daler/zenburn.nvim", lazy = false, priority = 1000 }, -- colorscheme
  { "folke/which-key.nvim", lazy = false, config = true, commit = "0539da005b98b02cf730c1d9da82b8e8edb1c2d2" }, -- pop up a window showing possible keybindings
  { "morhetz/gruvbox", enabled = false }, -- example of an alternative colorscheme, here disabled
  { "joshdick/onedark.vim", lazy = false }, -- another colorscheme, here enabled as a fallback for terminals with no true-color support like Terminal.app.
  { "norcalli/nvim-colorizer.lua", config = true, lazy = true, cmd = "ColorizerToggle" }, -- color hex codes by their actual color
  {
    "EdenEast/nightfox.nvim", -- family of colorschemes (nightfox, dawnfox, terrafox, etc)
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          styles = { comments = "italic" },
        },
      })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua", -- file browser
    lazy = false, -- otherwise, opening a directory as first buffer doesn't trigger it.
    config = true,
    keys = {
      { "<leader>fb", "<cmd>NvimTreeToggle<CR>", desc = "[f]ile [b]rowser toggle" },
    },
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
          -- use a previewer that doesn't show each file's contents
          local previewer = require("telescope.themes").get_dropdown({ previewer = false })
          require("telescope.builtin").find_files(previewer)
        end,
        desc = "[f]ind [f]iles",
      },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "[f]ind with [g]rep in directory" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
      { "<leader>fc", "<cmd>Telescope treesitter<CR>", desc = "[f]ind [c]ode object" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "[f]ind [r]ecently-opened files" },
    },
  },

  {
    "danilamihailov/beacon.nvim", -- flash a beacon to show where you are
    commit = "5ab668c4123bc51269bf6f0a34828e68c142e764", -- later versions are lua-only and not as nice to configure
    lazy = false, -- otherwise, on first KJ you get a double-flash
    config = function()
      -- Disable the beacon globally; only the commands below will activate it.
      vim.cmd("let g:beacon_enable=0")
    end,
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
    "akinsho/toggleterm.nvim", -- terminal in vim you can send code to
    commit = "c80844fd52ba76f48fabf83e2b9f9b93273f418d", -- later versions break sending visual selection with gxx
    config = function()
      -- tweak the sizes of the new terminal
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.5
          end
        end,
      })
      -- Always use insert mode when entering a terminal buffer, even with mouse click.
      -- NOTE: Clicking with a mouse a second time enters visual select mode, just like in a text buffer.
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          vim.cmd("if &buftype == 'terminal' | startinsert | endif")
        end,
      })
    end,
    keys = {
      { "gxx", ":ToggleTermSendCurrentLine<CR><CR>", desc = "Send current line to terminal" },
      { "gx", ":ToggleTermSendVisualSelection<CR>'><CR>", desc = "Send selection to terminal", mode = "x" },
      {
        "<leader>cd",
        "/```{r<CR>NjV/```<CR>k<Esc>:ToggleTermSendVisualSelection<CR>/```{r<CR>",
        desc = "Send RMarkdown chunk to R",
      },
      -- Immiedately after creating the terminal, disable the cursorline.
      -- This otherwise looks confusing with a single, differently-colored line at
      -- the bottom of the terminal when commands are running.
      { "<leader>t", ":ToggleTerm direction=vertical<CR><C-\\><C-n>:set nocul<CR>i", desc = "New terminal on right" },
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
        },
        indent = {
          enable = true,
          -- Let vim-python-pep8-indent handle the python and snakemake indentation;
          -- disable markdown indentation because it prevents bulleted lists from wrapping correctly with `gq`.
          disable = { "python", "snakemake", "markdown" },
        },
        -- These will be attempted to be installed automatically, but you'll need a C compiler installed.
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
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
    "lukas-reineke/indent-blankline.nvim", -- show vertical lines at tabstops
    lazy = false,
    main = "ibl",
    opts = {
      indent = { char = "┊" }, -- make the character a little less dense
      exclude = { filetypes = {"markdown", "rst" } },
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
      { "{", "<cmd>AerialPrev<CR>", desc = "Prev code symbol" },
      { "}", "<cmd>AerialNext<CR>", desc = "Next code symbol" },
      { "<leader>a", "<cmd>AerialToggle<CR>", desc = "Toggle [a]erial nav" },
    },
  },

  {
    "lewis6991/gitsigns.nvim", -- show changes in file, when working in a git repo
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select hunk")
      end,
    },
  },

  {
    "nvim-lualine/lualine.nvim", -- status line along the bottom
    dependencies = {
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
      require("lualine").setup({
        options = { theme = "zenburn" },
        sections = {
          lualine_c = { { "filename", path = 2 } },
          lualine_x = {
            function()
              return require("lsp-progress").progress()
            end,
          },
        },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    config = true,
    lazy = false, -- tabs for buffers along the top
    keys = {
      { "<leader>b", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
    },
    opts = {
      options = {
        -- right_mouse_command = "vertical sbufer %d",
        -- separator_style = "slant",
        -- hover = {
        --   enabled = true,
        --   delay = 200,
        --   reveal = { "close" },
        -- },
        diagnostics = "nvim_lsp",
        custom_filter = function(buf_number, buf_numbers)
          if vim.bo[buf_number].filetype ~= "fugitive" then
            return true
          end
        end,
        show_buffer_icons = false,
        offsets = {
          {
            filetype = "NvimTree",
            highlight = "Directory",
            separator = true,
          },
          {
            filetype = "aerial",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
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
  {
    "williamboman/mason.nvim", -- convenient installation of LSP clients
    lazy = false,
    config = true,
  },
  {
    "neovim/nvim-lspconfig", -- convenient configuration of LSP clients

    cmd = "LspStart",

    init = function()
      local lspconfig = require("lspconfig")

      -- Below, autostart = false means that you need to explicity call :LspStart (<leader>cl)
      --
      -- pyright is the language server for Python
      lspconfig.pyright.setup({ autostart = false })

      lspconfig.bashls.setup({ autostart = false })

      -- language server for R
      lspconfig.r_language_server.setup({ autostart = false })

      -- Language server for Lua. These are the recommended options
      -- when mainly using Lua for Neovim
      lspconfig.lua_ls.setup({
        autostart = false,
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
      })

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
  {
    "folke/trouble.nvim", -- split window to show issues found by LSP
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ct", "<cmd>TroubleToggle<CR>", desc = "Toggle trouble.nvim" },
    },
  },

  {
    "stevearc/conform.nvim", -- run code through formatter
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
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
        bash = { { "shfmt" } },
        sh = { { "shfmt" } },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
      },
      init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
    },
  },

  {
    "folke/flash.nvim", -- search and select, including with treesitter
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  {
    "stevearc/stickybuf.nvim", -- Prevents opening buffers in terminal buffer
    opts = {},
    config = function()
      require("stickybuf").setup({
        get_auto_pin = function(bufnr)
          return require("stickybuf").should_auto_pin(bufnr)
        end,
      })
    end,
  },

  {
    "linrongbin16/lsp-progress.nvim", -- Adds LSP status to the bottom line so you know it's running
    config = function()
      require("lsp-progress").setup()
    end,
  },
  {
    "epwalsh/obsidian.nvim", -- convenient highlighting for markdown, and obsidian-like notes
    version = "*",
    lazy = true,
    ft = "markdown",
    preferred_link_style = "markdown",
    event = {"BufReadPre " .. vim.fn.expand "~" .. "/notes/**.md"},
    dependencies = { "nvim-lua/plenary.nvim", },
    opts = {

      disable_frontmatter = true,
      ui = { enable = false },
      mappings = {
      -- Default <CR> mapping will toggle a checkbox if not in a link or follow it if in a link.
      -- This makes it only follow a link.
        ["<CR>"] = {
        action = function()
          if require('obsidian').util.cursor_on_markdown_link(nil, nil, true) then
            return "<cmd>ObsidianFollowLink<CR>"
          end
        end,
          opts = { buffer = true, expr = true },
        },
      },
      -- default is to add a unique id to the beginning
      note_id_func = function(title)
        return title
      end,

      -- default is "wiki"; this keeps it regular markdown
      preferred_link_style = "markdown",

      -- Set this to where you're storing your local notes
      workspaces = {
        {
          name = "no-vault",
          path = function() return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0))) end,
          overrides = {
            notes_subdir = vim.NIL,
            new_notes_location = "current_dir",
            templates = { folder = vim.NIL, },
            disable_frontmatter = true,
          },
        },
      },

      -- Open URL under cursor in browser (uses `open` for MacOS)
      follow_url_func = function(url) vim.inspect(vim.system({"open", url})) end,
    },
    keys = {
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "[o]bsidian [s]earch" },
      { "<leader>on", "<cmd>ObsidianLinkNew<cr>", mode = { "v" },  desc = "[o]bsidian [n]ew link" },
      { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = {"v"}, desc = "[o]bsidian [l]ink to existing" },
      { "<leader>od", "<cmd>ObsidianDailies -999 0<cr>", desc = "[o]bsidian [d]ailies" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "[o]bsidian [t]ags" },
    },
  },
}
-- vim: nowrap

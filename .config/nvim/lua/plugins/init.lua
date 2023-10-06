-- Return the plugin spec. Note that plugins with additional config are placed
-- in their own files in the plugins/ dir.

return {
  { "vim-pandoc/vim-pandoc-syntax" },
  { "vim-pandoc/vim-rmarkdown" },
  { "vim-scripts/vis" },
  { "Vimjas/vim-python-pep8-indent" },
  { "chrisbra/vim-diff-enhanced" },
  { "dhruvasagar/vim-table-mode" },
  { "junegunn/gv.vim" },
  { "roxma/vim-tmux-clipboard" },
  { "samoshkin/vim-mergetool" },
  { "tpope/vim-commentary" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-surround" },
  { "tpope/vim-sleuth" },
  { "nvim-lua/plenary.nvim" },
  { "rafamadriz/friendly-snippets" },
  { "rktjmp/lush.nvim" },
  { "sindrets/diffview.nvim" },
  { "folke/which-key.nvim" },
  { "phha/zenburn.nvim", lazy = false, priority = 1000 },
  { "ziontee113/color-picker.nvim" }, 

  -- NOTE: Some plugins have additional configuration, which can get verbose if
  -- all listed inline here. So they are moved to their own files. The plugins are
  -- listed here for reference, but see their files for the actuall
  -- configuration.
  --
  -- PLUGIN SPEC                             FILE
  -- ======================================  ==========================
  -- {'nvim-telescope/telescope.nvim'}       -- telescope.lua
  -- {'danilamihailov/beacon.nvim'}          -- beacon.lua
  -- {'rhysd/accelerated-jk'}                -- accelerated-jk.lua
  -- {'phha/zenburn.nvim'}                   -- zenburn.lua
  -- {'vim-pandoc/vim-pandoc'}               -- vim-pandoc.lua
  -- {'akinsho/toggleterm.nvim'}             -- toggleterm.lua
  -- {'nvim-treesitter/nvim-treesitter'}     -- treesitter.lua
  -- {'hrsh7th/nvim-cmp'}                    -- nvim-cmp.lua
  -- {'ggandor/leap.nvim'}                   -- leap.lua
  -- {'vim-airline/vim-airline'}             -- vim-airline.lua
  -- {'lukas-reineke/indent-blankline.nvim'} -- indent-blankline.lua
  -- {'lewis6991/gitsigns.nvim'}             -- gitsigns.lua
}

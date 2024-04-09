-- Lua config for neovim. Coming from Vim lanuage? See
-- https://neovim.io/doc/user/lua.html for the basics.

-- leader must be set before plugins are set up.
vim.cmd("let mapleader=','") -- Re-map leader from default \ to , (comma)
vim.cmd("let maplocalleader = '\\'") -- Local leader becomes \.

-- This allows nvim-tree to be used when opening a directory in nvim.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd("set termguicolors") -- use full color in colorschemes

-- Bootstrap lazy.nvim in case it's not already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--
-- Plugins.
-- Plugins are handled separately, see the lua/plugins.lua file.
-- This command tells lazy.nvim, the plugin manager, where to find that file.
--
require("lazy").setup("plugins")

--
-- Colorscheme.
-- Add your favorite colorscheme to lua/plugins.lua, and use it here.
--
vim.cmd("colorscheme zenburn")

-- Uncomment these lines if you use a terminal that does not support true color:
-- vim.cmd("colorscheme onedark")
-- vim.cmd("set notermguicolors")

--
-- Settings.
-- You can use vim.cmd() to execute any standard vim command. Many of these can
-- be converted to Lua syntax, like vim.o.mouse = "a", but for consistency with
-- earlier versions of this config, we're keeping the vim syntax for now.
vim.cmd("syntax on") -- Syntax highlighting; also does an implicit filetype on
vim.cmd("filetype plugin indent on") -- Enable detection, plugin, and indent for filetype
vim.cmd("set nofoldenable") -- Files will open with everything unfolded
vim.cmd("set backspace=indent,eol,start") -- Make backspace work as expected in some situations
vim.cmd("set smarttab") -- Insert spaces according to shiftwidth at the beginning of each line
vim.cmd("set expandtab") -- <Tab> inserts spaces, not "\t"
vim.cmd("set whichwrap+=<,>,h,l") -- arrows and h and l move over new lines
vim.cmd("set scrolloff=3") -- Keep some lines above and below cursor to keep it visible
vim.cmd("set list") -- Show non-printing characters
vim.cmd("set showmatch") -- Show matching parentheses
vim.cmd("set nu") -- Show line numbers
vim.cmd("set noshowmode") -- For use with vim-airline, which has its own
vim.cmd("set mouse=a") -- Allow mouse usage.
vim.cmd(":autocmd InsertEnter * set listchars=tab:>•") -- Display nonprinting characters (tab characters and trailing spaces).
vim.cmd(":autocmd InsertLeave * set listchars=tab:>•,trail:∙,nbsp:•,extends:⟩,precedes:⟨") -- also show trailing spaces after exiting insert mode
vim.cmd("set formatoptions=qrn1coj") --  Changes the behavior of various formatting; see :h formatoptions.
vim.cmd("set hidden") -- Open a new buffer without having to save first
vim.cmd("set noswapfile") -- Disable swap file creation. Keep enabled for huge files (:set swapfile)
vim.cmd("autocmd BufEnter * silent! lcd %:p:h") -- Set the working directory to that of the opened file
vim.cmd("set ignorecase") -- Ignore case when searching...
vim.cmd("set smartcase") -- ...unless at least one character is uppercase
vim.cmd("set nohlsearch ") -- Don't highlight search items by default
vim.cmd("set wildmenu") -- Make tab completion for files/buffers act like bash
vim.cmd("set wildmode=list:full") -- Show a list when pressing tab; complete first full match
vim.cmd("set wildignore=*.swp,*.bak,*.pyc,*.class") -- Ignore these when autocompleting
vim.cmd("set cursorline") -- Highlight line where the cursor is
-- vim.cmd(":autocmd InsertEnter * set cul") -- Color the current line in upon entering insert mode
-- vim.cmd(":autocmd InsertLeave * set nocul") -- Remove color upon existing insert mode
-- vim.cmd("set guicursor=i:block") -- Always use block cursor. In some terminals and fonts (like iTerm), it can be hard to see the cursor when it changes to a line.

--
-- Keymappings
-- These are general keymappings. For keymappings related to plugins, see
-- lua/plugins.lua. Many keymappings have descriptions which will show up in
-- which-key.
--
-- 
local wk = require('which-key')
wk.register( { ["<leader>c"] = { name = "+code" } } )
wk.register( { ["<leader>f"] = { name = "+file or +find" } } )

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>") -- Fix <Esc> in terminal buffer
vim.keymap.set("n", "<Leader>H", ":set hlsearch!<CR>", { desc = "Toggle search highlight" })
vim.keymap.set("n", "<leader>W", ":%s/\\s\\+$//<cr>:let @/=''<CR>", { desc = "Clean trailing whitespace" })
vim.keymap.set({ "n", "i" }, "<leader>R", "<Esc>:syntax sync fromstart<CR>", { desc = "Refresh syntax highlighting" })
vim.keymap.set({ "n", "i" }, "<leader>`", "<Esc>i```{r}<CR>```<Esc>O", { desc = "New fenced RMarkdown code block" })
vim.keymap.set(
  { "n", "i" },
  "<leader>ts",
  '<Esc>o<Esc>:r! date "+[\\%Y-\\%m-\\%d \\%H:\\%M] "<CR>A',
  { desc = "Insert timestamp" }
)
vim.keymap.set("n", "<leader>-", "80A-<Esc>d80<bar>", { desc = "Fill rest of line with -" })
vim.keymap.set("n", "<leader><tab>", ":set nowrap tabstop=", { desc = "Prepare for viewing TSV" })
vim.keymap.set("n", "<leader>1", ":bfirst<CR>", { desc = "First buffer" })
vim.keymap.set("n", "<leader>2", ":blast<CR>", { desc = "Last buffer" })
vim.keymap.set("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "H", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "L", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>cp", ":IBLToggle<CR>:set nu!<CR>", { desc = "Prepare for copying text to another program"}) 

-- Keymappings for navigating terminals.
-- <leader>q and <leader>w move to left and right windows respectively. Useful
-- when working with a terminal. Works even in insert mode; to enter a literal
-- ',w' type more slowly after the leader.
vim.keymap.set({ "n", "i" }, "<leader>w", "<Esc>:wincmd l<CR>", { desc = "Move to right window" })
vim.keymap.set({ "n", "i" }, "<leader>q", "<Esc>:wincmd h<CR>", { desc = "Move to left window" })
vim.keymap.set("t", "<leader>q", "<C-\\><C-n>:wincmd h<CR>", { desc = "Move to left window" })

vim.fn.setreg("l", "I'A',j") -- "listify": wrap with quotes and add trailing comma

vim.cmd("hi @text.literal.block.markdown gui=NONE") -- Turn of the default italic italics on fenced code blocks in markdown/rmarkdown

-- Autocommands.
-- Autocommands are triggered by an action, like opening a particular filetype.

-- <leader>d inserts a header for today's date. Different commands depending on
-- the format of the filetype (ReStructured Text or Markdown)
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "rst",
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<leader>d",
      '<Esc>:r! date "+\\%Y-\\%m-\\%d"<CR>A<CR>----------<CR>',
      { desc = "Insert date as section title" }
    )
    vim.keymap.set(
      "n",
      "<leader>p",
      'i` <>`__<Esc>F<"+pF`a',
      { desc = "Paste a ReST-formatted link from system clipboard" }
    )
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "markdown", "rmd" },
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<leader>d",
      '<Esc>:r! date "+\\# \\%Y-\\%m-\\%d"<CR>A',
      { desc = "Insert date as section title" }
    )

    vim.keymap.set(
      "n",
      "<leader>p",
      'i[]()<Esc>h"+pF]i',
      { desc = "Paste a Markdown-formatted link from system clipboard" }
    )
  end,
})

-- Tell nvim about the snakemake filetype
vim.filetype.add({
  filename = {
    ["Snakefile"] = "snakemake",
  },
  pattern = {
    ["*.smk"] = "snakemake",
    ["*.snakefile"] = "snakemake",
    ["*.snakemake"] = "snakemake",
    ["Snakefile*"] = "snakemake",
  },
})

-- Set commentstring for snakemake, which is needed for vim-commentary
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snakemake",
  callback = function() vim.cmd("set commentstring=#\\ %s") end,
})


-- Render RMarkdown in R running in terminal
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rmarkdown", "rmd" },
  callback = function()
    vim.keymap.set(
      "n",
      "<leader>k",
      ":TermExec cmd='rmarkdown::render(\"%:p\")'<CR>",
      { desc = "Render RMar[k]down to HTML" }
    )
  end,
})

-- Run Python code in IPython running in terminal
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<leader>k", ":TermExec cmd='run %:p'<CR>", { desc = "Run Python file in IPython" })
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank{higroup = "IncSearch", timeout=100}
  end,
  pattern = "*",
})

-- Modified from https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close.
-- If the last buffer(s) open are nvim-tree or trouble.nvim or aerial, then close them all and quit.
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local close_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then  -- nvim-tree buffer
        table.insert(close_wins, w)
      end
      if bufname:match("Trouble") ~= nil then    -- trouble.nvim buffer
        table.insert(close_wins, w)
      end
      if bufname:match("Scratch") ~= nil then    -- aerial buffer
        table.insert(close_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= "" then -- floating windows
        table.insert(floating_wins, w)
      end
    end

    -- If the buffer we are closing during this QuitPre action is the only one
    -- that does not match the above patterns, then consider it the last text buffer,
    -- and close all other buffers.
    if 1 == #wins - #floating_wins - #close_wins then
      for _, w in ipairs(close_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})

-- vim: nowrap

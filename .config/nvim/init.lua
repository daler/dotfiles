-- Lua config for neovim. Coming from Vim lanuage? See
-- https://neovim.io/doc/user/lua.html for the basics.

-- leader must be set before plugins are installed
vim.cmd("let mapleader=','") -- Re-map leader from default \ to , (comma)
vim.cmd("let maplocalleader = '\\'") -- Local leader becomes \.

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
--
require("lazy").setup("plugins")

--
-- Colorscheme.
-- Add your favorite colorscheme to lua/plugins.lua, and use it here.
--
vim.cmd("colorscheme zenburn") -- bottom of this file has some tweaks to zenburn

--
-- Settings.
-- You can use vim.cmd() to execute any standard vim command. Many of these can
-- be converted to Lua syntax, like vim.o.mouse = "a", but for consistency with
-- earlier versions of this config, we're keeping the vim syntax for now.
--
vim.cmd("set termguicolors") -- use full color in colorschemes
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
vim.cmd(":autocmd InsertEnter * set cul") -- Color the current line in upon entering insert mode
vim.cmd(":autocmd InsertLeave * set nocul") -- Remove color upon existing insert mode
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
vim.cmd("set guicursor=i:block") -- Always use block cursor. In some terminals and fonts (like iTerm), it can be hard to see the cursor when it changes to a line.

--
-- Keymappings
-- These are general keymappings. For keymappings related to plugins, see
-- lua/plugins.lua. Many keymappings have descriptions which will show up in
-- which-key.
--
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>") -- Fix <Esc> in terminal buffer
vim.keymap.set("n", "<Leader>H", ":set hlsearch!<CR>", { desc = "Toggle search highlight" })
vim.keymap.set("n", "<leader>W", ":%s/\\s\\+$//<cr>:let @/=''<CR>", { desc = "Clean trailing whitespace" })
vim.keymap.set({ "n", "i" }, "<leader>R", "<Esc>:syntax sync fromstart<CR>", { desc = "Refresh syntax highlighting" })
vim.keymap.set({ "n", "i" }, "<leader>`", "i```{r}<CR>```<Esc>O", { desc = "New fenced RMarkdown code block" })
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
vim.keymap.set("n", "<leader>b", ":buffers<CR>:buffer<Space>", { desc = "Select buffer" })

-- Keymappings for navigating terminals.
-- <leader>q and <leader>w move to left and right windows respectively. Useful
-- when working with a terminal. Works even in insert mode; to enter a literal
-- ',w' type more slowly after the leader.
vim.keymap.set({ "n", "i" }, "<leader>w", "<Esc>:wincmd l<CR>", { desc = "Move to right window" })
vim.keymap.set({ "n", "i" }, "<leader>q", "<Esc>:wincmd h<CR>", { desc = "Move to left window" })
vim.keymap.set("t", "<leader>q", "<C-\\><C-n>:wincmd h<CR>", { desc = "Move to left window" })

vim.fn.setreg("l", "I'A',j") -- "listify": wrap with quotes and add trailing comma

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
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<leader>d",
      '<Esc>:r! date "+\\# \\%Y-\\%m-\\%d"<CR>A',
      { desc = "Insert date as section title" }
    )
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

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
})

-- Modifications to the zenburn colorscheme.
-- Collectively, this makes line numbers more obvious, fixes some diff
-- coloring, and makes bash and python highlighting look more like the older
-- zenburn. Some hints for tweaking colorschemes:
--
--  *  Use :Inspect to see what highlight group the cursor is over.
--  *  Use :Telescope higlight to search for it and find the current setting

if vim.api.nvim_exec("colorscheme", true) == "zenburn.nvim" then
  -- If there's a good highlight existing, link to that
  vim.api.nvim_set_hl(0, "@variable", { link = "Normal" })
  vim.api.nvim_set_hl(0, "diffAdded", { fg="#9ECE9E", bg="#313C36" })
  vim.api.nvim_set_hl(0, "diffRemoved", { fg="#ECBCBC", bg="#41363C"})
  vim.api.nvim_set_hl(0, "diffLine", { link = "MoreMsg" })

  vim.cmd("highlight LineNr guifg=#959898 guibg=#353535")
  vim.cmd("highlight CursorLineNr guifg=#f2f48d guibg=#2f2f2f")
  vim.cmd("highlight IncSearch guifg=#f8f893 guibg=#385f38")
  vim.cmd("highlight Comment cterm=italic gui=italic")
  vim.cmd("highlight DiffDelete guifg=#9f8888 guibg=#464646")
  vim.cmd("highlight Constant guifg=#dcdccc gui=bold")
  vim.cmd("highlight Boolean guifg=#FFCFAF gui=bold")
  vim.cmd("highlight Function guifg=#f6f6ab")
  vim.cmd("highlight @punctuation.bracket.bash guifg=#FFCFAF")
  vim.cmd("highlight @punctuation.special.bash guifg=#FFCFAF")
  vim.cmd("highlight @constant.bash guifg=#FFCFAF")
  vim.cmd("highlight @variable.bash guifg=#FFCFAF")
  vim.cmd("highlight IblScope guifg=#efefaf")
  vim.cmd("highlight @ibl.scope.char.1 guifg=#efefaf")
  vim.cmd("highlight Beacon guibg=white ctermbg=15")

end

-- vim: nowrap

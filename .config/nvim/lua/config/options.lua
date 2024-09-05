-- Global options.
vim.opt.syntax = "on" -- Syntax highlighting; also does an implicit filetype on
vim.opt.foldenable = false -- Files will open with everything unfolded
vim.opt.backspace = "indent,eol,start" -- Make backspace work as expected in some situations
vim.opt.smarttab = true -- Insert spaces according to shiftwidth at the beginning of each line
vim.opt.expandtab = true -- <Tab> inserts spaces, not "\t"
vim.opt.scrolloff = 3 -- Keep some lines above and below cursor to keep it visible
vim.opt.list = true -- Show non-printing characters
vim.opt.showmatch = true -- Show matching parentheses
vim.opt.nu = true -- Show line numbers
vim.opt.showmode = false -- The lualine plugin provides modeline for us

-- In addition to allowing clicking and scrolling, vim.opt.mouse = "a" also:
--  * Supports mouse-enabled motions. To try this, left-click to place the
--    cursor. Type y then left-click to yank from current cursor to where you
--    next clicked.
--  * Drag the status-line or vertical separator to resize
--  * Double-click to select word; triple-click for line
vim.opt.mouse = "a"

-- Change the behavior of various formatting.
-- Explanation of these options; see :h formatoptions for more info.
--   q: gq also formats comments
--   r: insert comment leader after <Enter> in insert mode
--   n: recognize numbered lists
--   1: don’t break a line after a 1-letter word
--   c: autoformat comments
--   o: automatically insert comment leader afer ‘o’ or ‘O’ in Normal mode.
--   j: where it makes sense, remove a comment leader when joining lines
vim.opt.formatoptions="qrn1coj"

vim.opt.hidden = true -- Open a new buffer without having to save first
vim.opt.swapfile = false -- Disable swap file creation. Keep enabled for huge files (:set swapfile)
vim.opt.ignorecase = true -- Ignore case when searching...
vim.opt.smartcase = true -- ...unless at least one character is uppercase
vim.opt.hlsearch = false -- Don't highlight search items by default
vim.opt.wildmenu = true -- Make tab completion for files/buffers act like bash
vim.opt.wildmode="list:full" -- Show a list when pressing tab; complete first full match
vim.opt.wildignore:append("*.swp,*.bak,*.pyc,*.class") -- Ignore these when autocompleting
vim.opt.cursorline = true  -- Highlight line where the cursor is
vim.opt.fillchars:append { diff = "╱" } -- in diffs, show deleted lines with slashes rather than dashes

-- vim.cmd(":autocmd InsertEnter * set cul") -- Color the current line in upon entering insert mode
-- vim.cmd(":autocmd InsertLeave * set nocul") -- Remove color upon existing insert mode
-- vim.cmd("set guicursor=i:block") -- Always use block cursor. In some terminals and fonts (like iTerm), it can be hard to see the cursor when it changes to a line.

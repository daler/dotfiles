-- GENERAL SETTINGS

vim.cmd("set termguicolors") -- Enables 24-bit RGB color, using "gui" highlight rather than "cterm"
vim.cmd("colorscheme zenburn") -- Set colorscheme
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
-- vim: nowrap

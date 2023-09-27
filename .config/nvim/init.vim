call plug#begin()

" See https://daler.github.io/dotfiles/vim.html#plugins for documentation on
" each plugin. Search this config for the plugin name to find config options
" for it.

Plug 'akinsho/toggleterm.nvim' " Easily interact with a terminal within vim.
Plug 'Vimjas/vim-python-pep8-indent' " Indent python using pep8 recommendations (does not add any commands).
Plug 'chrisbra/vim-diff-enhanced' " Provides additional diff algorithms
Plug 'dhruvasagar/vim-table-mode' " Very easily make and work with markdown and restructured text tables.
Plug 'ervandew/supertab' " Autocomplete most things.
Plug 'flazz/vim-colorschemes' " Lots of colorschemes, including 'zenburn' which is configured below
Plug 'ggandor/leap.nvim' " Jump around in a buffer with low mental effort
Plug 'junegunn/gv.vim' " Easily view and browse git history
Plug 'phha/zenburn.nvim' " updated zenburn colorscheme
Plug 'preservim/nerdtree' " A file browser for vim.
Plug 'roxma/vim-tmux-clipboard' " Automatically shares vim and tmux clipboards
Plug 'samoshkin/vim-mergetool' " Makes dealing with 3-way merge conflicts much easier
Plug 'tmhedberg/SimpylFold' " Nice folding for Python
Plug 'tpope/vim-commentary' " Toggle comments
Plug 'tpope/vim-fugitive' " Run git interactively from vim
Plug 'tpope/vim-surround' " Change surrounding characters.
Plug 'vim-airline/vim-airline' " Adds a nice statusline at the bottom and bufferline along the top.
Plug 'vim-airline/vim-airline-themes' " Used for the statusline and bufferline provided by vim-airline.
Plug 'vim-pandoc/vim-pandoc' " Interfaces with pandoc, required for vim-rmarkdown
Plug 'vim-pandoc/vim-pandoc-syntax' " Separate plugin for pandoc syntax, required by vim-pandoc
Plug 'vim-pandoc/vim-rmarkdown' " Supports syntax highlighting in RMarkdown chunks
Plug 'vim-python/python-syntax' " Improved python syntax highlighting
Plug 'vim-scripts/vis' " Makes operations in visual block mode respect selection.
Plug 'lukas-reineke/indent-blankline.nvim' " adds vertical lines as indentation guides
Plug 'tpope/vim-sleuth' " Detect and set shiftwidth/tabstop appropriately per buffer

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'folke/which-key.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.3' }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'mfussenegger/nvim-lint'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/vim-vsnip'

" Plug 'nvim-lualine/lualine.nvim'
" Plug 'akinsho/bufferline.nvim'
call plug#end()

" LUA CONFIG  ================================================================
if has('nvim')
    " For nvim-specific functionality, there is a separate Lua config
    lua require('plugin-config')
    set inccommand=nosplit " Live preview of search and replace
endif


" SETTINGS ===================================================================
syntax on  " Syntax highlighting; also does an implicit filetype on
filetype plugin indent on " Enable detection, plugin , and indent for filetype
set nofoldenable " Files will open with everything unfolded; fold commands like zc will re-enable it.
set foldlevel=99 " Support this many levels of nested folds
set backspace=indent,eol,start " This gets backspace to work in some situations
set smarttab " At the beginning of the line, insert spaces according to shiftwidth
set expandtab " <Tab> inserts spaces, not '\t'
set whichwrap+=<,>,h,l " Allows arrows and h/l to move to next line when at the end of one
set scrolloff=3 " Keep some lines above and below the cursor to keep context visible
set list " Show non-printing chars
set showmatch " Show matching parentheses
set nu " Display line numbers
set wrap " Wrap lines
set noshowmode " For use with vim-airline, which has its own
set mouse=a " Allow mouse usage.
:autocmd InsertEnter * set cul " Color the current line in upon entering insert mode
:autocmd InsertLeave * set nocul " Remove color upon existing insert mode
:autocmd InsertEnter * set listchars=tab:>• " Display nonprinting characters (tab characters and trailing spaces).
:autocmd InsertLeave * set listchars=tab:>•,trail:∙,nbsp:•,extends:⟩,precedes:⟨ " also show trailing spaces after exiting insert mode
set formatoptions=qrn1coj "  Changes the behavior of various formatting; see :h formatoptions.
set hidden " Open a new buffer without having to save first
set noswapfile " Disable swap file creation. Keep enabled for huge files (:set swapfile)
autocmd BufEnter * silent! lcd %:p:h " Set the working directory to that of the opened file
set ignorecase " Ignore case when searching...
set smartcase " ...unless at least one character is uppercase
set nohlsearch " Don't highlight search items by default
set wildmenu " Make tab completion for files/buffers act like bash
set wildmode=list:full " Show a list when pressing tab; complete first full match
set wildignore=*.swp,*.bak,*.pyc,*.class " Ignore these when autocompleting

" COLORS =====================================================================
:silent! colorscheme zenburn " Set colorscheme here
set guicursor=i:block " Always use block cursor. In some terminals and fonts (like iTerm), it can be hard to see the cursor when it changes to a line.
set termguicolors " 24-bit color. Subtly changes some colors, like terminal background and highlights. Also allows comments to be italic.

" In some circumstances, the background highlight when selecting text can be bright teal when using zenburn. This fixes it to light gray.
hi Visual guibg=#555555 guifg=NONE

" CUSTOM MAPPINGS ============================================================
" NOTE: Comments cannot be on the same line when remapping.
"
" Re-map leader from default \ to , (comma). Any time <leader> is used below, it now
" means comma.
let mapleader=","

" And now the local leader is \
let maplocalleader = "\\"

" <leader>H to toggle search highlight
noremap <leader>H :set hlsearch!<CR>

" <leader>W cleans up trailing whitespace in entire file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" <leader>R refreshes syntax highlighting. Useful when syntax highlighting seems wonky.
noremap <leader>R <Esc>:syntax sync fromstart<CR>
inoremap <leader>R <C-o>:syntax sync fromstart<CR>

" <leader>` (backtick) creates a new fenced RMarkdown code block, ready to type in. This works in insert or normal mode.
noremap <leader>` i```{r}<CR>```<Esc>O
inoremap <leader>` <C-o>i```{r}<CR>```<Esc>O

" @l will 'listify', surrounding with quotes and adding a trailing comma. Used for easily making Python lists out of pasted text.
let @l = "I'A',j"

" <leader>ts inserts a timestamp. Useful when writing logs.
inoremap <leader>ts <Esc>o<Esc>:r! date "+[\%Y-\%m-\%d \%H:\%M] "<CR>A
noremap <leader>ts <Esc>o<Esc>:r! date "+[\%Y-\%m-\%d \%H:\%M] "<CR>A

" <leader>d inserts a ReST-formatted title for today's date. Only works in ReST files.
autocmd FileType rst inoremap <leader>d <Esc>:r! date "+\%Y-\%m-\%d"<CR>A<CR>----------<CR>
autocmd FileType rst noremap  <leader>d <Esc>:r! date "+\%Y-\%m-\%d"<CR>A<CR>----------<CR><Esc>

" <leader>d inserts a Markdown header for today's date. Only works in markdown files.
autocmd FileType markdown inoremap <leader>d <Esc>:r! date "+\# \%Y-\%m-\%d"<CR>A
autocmd FileType markdown noremap  <leader>d <Esc>:r! date "+\# \%Y-\%m-\%d"<CR>A

" <leader>- fills in the rest of the line with dashes
nnoremap <leader>- 80A-<Esc>d80<bar>

" <leader>md hard-wraps at 80 columns and reformats paragraphs as they are written.
" Mnemonic is md = 'markdown', a common filetype where this is useful
nnoremap <leader>md :set tw=80 fo+=ta<CR>

" <leader>nd unsets the hard-wrap from <leader>md.
" Mnemonic is 'not markdown', to indicate the opposite of the ,md above.
nnoremap <leader>nd :set tw=80 fo-=ta<CR>

" <leader> <TAB> gives slightly saner behavior with long TSV lines.
" Leaves the cursor in the command bar so you can type in an appropriate tab stop value.
" Mnemonic of <tab> should be self-explanatory!
nnoremap <leader><tab> :set nowrap tabstop=

" <leader>r toggles relative numbering, useful for choosing how many lines to delete
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc
nnoremap <leader>r :call NumberToggle()<cr>

" Buffer switching ----------------------------------------------------------
" move between buffers. This is largely for backwards compatibility (and
" muscle memory) from previous configs.
nnoremap <leader>1 :bprevious<CR>
nnoremap <leader>2 :bnext<CR>

" This is now my favorite method for buffer switching because tab-completion
" works.
nnoremap <leader>b :buffers<CR>:buffer<Space>

" [b and ]b, borrowed from vim-unimpaired, is another mapping for this.
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

" Copy/paste -----------------------------------------------------------------
" Yank/paste to the OS clipboard with <leader>y and <leader>p
nmap <leader>y "+y
nmap <leader>Y "+yq
nmap <leader>p "+p
nmap <leader>P "+P

" <leader>q and <leader>w move to left and right windows respectively.
" Useful when working with a terminal.
" Works even in insert mode; to enter a literal ',w' type more slowly after the leader.
noremap <silent> <leader>w :wincmd l<cr>
inoremap <silent> <leader>w <Esc>:wincmd l<cr>
noremap <silent> <leader>q :wincmd h<cr>
tnoremap <silent> <leader>q <C-\><C-n>:wincmd h<cr>

" Always use insert mode when entering a terminal buffer, even with mouse click.
" NOTE: Clicking with a mouse a second time enters visual select mode, just like in a text buffer.
autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif

" Filetype-specific settings -------------------------------------------------
" Disable tab visibility for other filetypes that don't care
autocmd! FileType html,xml set listchars-=tab:>.

" Override the shiftwidth and tabstops for some file types
autocmd! FileType yaml,yml,r,rmarkdown,*.Rmd,*.rmd set shiftwidth=2 tabstop=2

" Consider any files with these names to be Python
au BufRead,BufNewFile Snakefile,*.snakefile,*.smk setfiletype python

" PLUGIN SETTINGS AND MAPPINGS ===============================================
"
" plugin: python-syntax ------------------------------------------------------
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1

" plugin: NERDTree -----------------------------------------------------------
" <leader>n toggles NERDTree window
nnoremap <leader>n :NERDTreeToggle<cr>

" plugin: ToggleTerm ---------------------------------------------------------
" <leader>t opens a terminal to the right (ToggleTerm)
nmap <leader>t :ToggleTerm direction=vertical<CR>

" When in a terminal, by default Esc does not go back to normal mode.
" Instead you need to use Ctrl-\ Ctrl-n. This remaps to use Esc.
tnoremap <Esc> <C-\><C-n>

" <leader>gxx sends current line to terminal
nmap gxx :ToggleTermSendCurrentLine<CR><CR>

" <leader>gx sends current selection (line or visual) to terminal
xmap gx :ToggleTermSendVisualSelection<CR><CR>

" <leader>k renders the current RMarkdown file to HTML (named after the current file)
:autocmd FileType rmarkdown nmap <leader>k :TermExec cmd='rmarkdown::render("%:p")'<CR>

" <leader>k runs the file in IPython when working in Python.
:autocmd FileType python nmap <leader>k :TermExec cmd='run %:p'<CR>

" <leader>cd sends RMarkdown code chunk and move to the next one.
"
" Breaking this down...
"
" /```{<CR>                                 -> search for chunk delimiter (recall <CR> is Enter)
" N                                         -> find the *previous* match to ```{
" j                                         -> move down one line from the previous match
" V                                         -> enter visual line-select mode
" /^```\n<CR>                               -> select until the next chunk delimiter by itself on the line (which should be the end)
" k                                         -> go up one line from that match so we don't include that line
" <Esc>:ToggleTermSendVisualSelection<CR>   -> send the selection to the terminal
" /```{r<CR>                                -> go to the start of the next chunk
nmap <leader>cd /```{<CR>NjV/```\n<CR>k<Esc>:ToggleTermSendVisualSelection<CR>/```{r<CR>

" <leader>yr adds commonly-used YAML front matter to RMarkdown documents.
" Mnemonic is 'YAML for RMarkdown'. It adds the following:
" ---
" output:
"   html_document:
"     code_folding: hide
"     toc: true
"     toc_float: true
"     toc_depth: 3
" ---
"
nmap <leader>yr i---<CR>output:<CR>  html_document:<CR>  code_folding: hide<CR>toc: true<CR>toc_float: true<CR>toc_depth: 3<CR><BS>---<Esc>0

" <leader>ko inserts a knitr global options chunk. Mnemonic is 'knitr options'
nmap <leader>ko i<CR>```{r}<CR>knitr::opts_chunk$set(warning=FALSE, message=FALSE)<CR>```<CR><Esc>0


" " plugin: vim-airline --------------------------------------------------------
" Only support a single extension to save a little on load time
let g:airline_extensions = ['tabline']
" " Enable the display of open buffers along the top.
" " Click on them or use <leader>1, <leader>2, etc to switch to them.
" " See :help airline-tabline for more.
let g:airline#extensions#tabline#enabled = 1
" 
" " Show the buffer number next to the filename for easier switching.
" " See :help airline-tabline for more.
" let g:airline#extensions#tabline#buffer_nr_show = 1
" 
" " Show only the filename and not the full path in buffer tabs.
" " See :help filename-modifiers for more info.
let g:airline#extensions#tabline#fnamemod = ':t'
" 
" " See https://github.com/vim-airline/vim-airline/wiki/Screenshots to choose other themes.
" " Use :AirlineTheme <themename> to test live.
let g:airline_theme = "ayu_dark"
" 
" " If you are using a powerline-enabled font in your terminal application, set this to 1. Otherwise set to 0.
" " See :help airline-configuration for more.
let g:airline_powerline_fonts = 1

" plugin: vim-pandoc and vim-pandoc-syntax -----------------------------------
" By default, keep spell-check off. Turn on with `set spell`
let g:pandoc#spell#enabled = 0

" Disable the conversion of ``` to lambda and other fancy concealment/conversion that ends up confusing me
let g:pandoc#syntax#conceal#use = 0

" RMarkdown code blocks can be folded too
let g:pandoc#folding#fold_fenced_codeblocks = 1

" plugin: indent-blankline.nvim ----------------------------------------------
nnoremap <leader>i :IndentBlanklineToggle<CR>

" vim: nowrap

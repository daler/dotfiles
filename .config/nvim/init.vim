call plug#begin()

" Plugins come from GitHub. Plug 'username/repo' can be found at
" https://github.com/user/repo.

" Vis
" ---
" Makes operations in visual block mode respect selection.
"
"   Use :B in front of commands (like s/) to make them use the current visual
"   block selection, which perhaps surprisingly does not happen by default
Plug 'vim-scripts/vis'

" NERDCommenter
" -------------
" Comments blocks of text.
"
"   Use ,cc to comment visual selection
"   Use ,ci to invert comment on selection
"
" See :help nerdcommenter for more
Plug 'preservim/nerdcommenter'

" NERDTree
" --------
" A file browser for vim.
"
"   Use ,n to toggle
"
" See :help NERDTree for much more
Plug 'preservim/nerdtree'

" vim-airline
" -----------
" Adds a nice statusline at the bottom and bufferline along the top.
"
" See the 'vim-airline' configuration section below. Use a powerline-enabled
" font for full effect.
Plug 'vim-airline/vim-airline'

" vim-airline-themes
" ------------------
" Used for the statusline and bufferline provided by vim-airline.
"
" See https://github.com/vim-airline/vim-airline/wiki/Screenshots for themes,
" and use :AirlineTheme <themename> to test them live.
Plug 'vim-airline/vim-airline-themes'

" vim-tmux-clipboard
" ------------------
" Automatically shares vim and tmux clipboards
"
" No added commands, but allows you to:
"   - Yank text in vim, and paste it into a tmux terminal elsewhere.
"   - Copy text anywhere in tmux, and paste it into any vim (that is also
"   running this plugin)
"
" Need to add 'set -g focus-events on' to your .tmux.conf
Plug 'roxma/vim-tmux-clipboard'

" python-syntax
" -------------
" Improved python syntax highlighting (does not add any commands).
Plug 'vim-python/python-syntax'

" vim-python-pep8-indent
" ----------------------
" Indent python using pep8 recommendations (does not add any commands).
Plug 'Vimjas/vim-python-pep8-indent'

" Autocomplete most things.
"
Plug 'ervandew/supertab'

" fugitive
" --------
" Run git interactively from vim.
"
"   Use :Git to get a text interface for incrementally making commits.
"   Use = when over a filename to toggle visibility of its changes
"   Use - in a chunk to stage it
"   Use - on a selection to stage just that selection
"   Use = over the staged section to toggle visibility of staged chunks
"   Use - over staged lines or chunks to unstage them
"   Use cc to commit, which opens a buffer to write in like normal git commits
Plug 'tpope/vim-fugitive'

" vim-diff-enhanced
" -----------------
" Provides additional diff algorithms
"   See :help EnhancedDiff for more
Plug 'chrisbra/vim-diff-enhanced'

" vim-rmarkdown, vim-pandoc, vim-pandoc-syntax
" --------------------------------------------
" These three plugins jointly provide syntax highlighting for RMarkdown. This
" allows R chunks to be formatted as R code.
"
" See vim-pandoc config section below.
Plug 'vim-pandoc/vim-rmarkdown'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" vim-table-mode
" --------------
" Very easily make and work with markdown and restructured text tables.
"
"   Use ,tm to toggle table mode (or use :TableModeEnable).
"   Type the header, separated by |
"   Use || on a new line to complete the header
"   Type subsequent rows, fields delimited by |
"   Complete the table with || above the first (header) line.
"
" Markdown or ReST format will be detected based on file type. See :help
" table-mode for more.
Plug 'dhruvasagar/vim-table-mode'

" SimpylFold
" ----------
" Nice folding for Python. Folds functions and classes; leaves loops and
" conditionals alone.
"
"   Use standard zc and zo to close and open folds
"   Use standard zM and zN to fold and unfold all
"
" See :help SimpylFold for more.
Plug 'tmhedberg/SimpylFold'

" gv.vim
" ------
" Easily view and browse git history
"
"  Use :GV to open commit browser
"  Use Enter on a commit to see it
"  Use :GV in visual mode to see commits affecting those lines
"  Use q to close the commit
"  Use q again to close gv.vim
Plug 'junegunn/gv.vim'

" vim-mergetool
" -------------
" Makes 3-way merge conflicts easier by only focusing on what needs to be
" manually edited. This requires the diff3 style following lines in your
" .gitconfig:
"
"   [merge]
"   conflictStyle = diff3
"
" Open a file with conflicts (like from a git merge). Then:
"   Use :MergetoolStart to start this tool
"   Either leave as-is, use :diffget to pull 'theirs', or manually edit each
"   diff.
"   When done, use :MergetoolStop
"
" See https://github.com/samoshkin/vim-mergetool for more.
Plug 'samoshkin/vim-mergetool'

" leap
" ----
" Jump around in a buffer with low mental effort
"
"   Look in the file where you want to go.
"
"   Use s to go below the current line
"   Use S to go above the current line
"
"   After hitting s or S, type two of the characters you want to leap to. You
"   will see highlighted letters pop up at all the possible destinations. Tap
"   the highlighted letter of the one corresponding to where you want to jump.
"
" This works best when your eyes are looking where you want to jump.
"
" See :help leap for more.
Plug 'ggandor/leap.nvim'

" vim-surround
" ------------
" Change surrounding characters.
"
"   Use cs"' when inside something with double quotes to change " to '.
"   Use ysiw" to add quotes around a word
"
" For a nice set of examples, see https://github.com/tpope/vim-surround, and
" see :help surround for more.
Plug 'tpope/vim-surround'

" ToggleTerm
" ----------
" Easily interact with a terminal within vim.
"
" This opens a terminal and allows you to send lines to it. Very useful for
" interactive Python and R work. See below ToggleTerm config for keymappings
" configured here, but briefly:
"
"   Use ,t to open a terminal to the right
"   Use ,w in normal mode to jump to the terminal
"   Use ,q in terminal to jump back to text buffer
"   Use ,gx on a selection to send it to the terminal
"   Use ,gxx on a line to send it to the terminal
"   Use ,cd to send an RMarkdown code chunk to the terminal (which is expected
"   to be running an R interpreter)
"
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

" vim-colorschemes
" ----------------
" Lots of colorschemes, including 'zenburn' which is configured below
Plug 'flazz/vim-colorschemes'

call plug#end()

" ============================================================================
" LUA SETUP
" ============================================================================
" Here, we run all of the Lua in one block.
if has('nvim')
    lua require('plugin-config')
endif


" ============================================================================
" SETTINGS
" ============================================================================
" Syntax highlighting; also does an implicit filetype on
syntax on

" Set colorscheme here
:silent! colorscheme zenburn

" Enable detection, plugin , and indent for filetype
filetype plugin indent on

" Files will open with everything unfolded; fold commands like zc will
" re-enable it.
set nofoldenable

" Support this many levels of nested folds. Use standard commands:
"   zm to fold everything
"   zn to unfold everything
"   zc to fold section
"   zi to unfold section
set foldlevel=99

" This gets backspace to work in some situations
set backspace=indent,eol,start

" Number of spaces <Tab> represents
set tabstop=4

" Number of spaces for indentation. Same as tabstop.
set shiftwidth=4

" At the beginning of the line, insert spaces according to shiftwidth
set smarttab

" <Tab> inserts spaces, not '\t'
set expandtab

" Allows arrows and h/l to move to next line when at the end of one
set whichwrap+=<,>,h,l

" Keep some lines above and below the cursor to keep context visible
set scrolloff=3

" Show non-printing chars
set list

" Show matching parentheses
set showmatch

" Display line numbers
set nu

" Wrap lines
set wrap

" For use with vim-airline, which has its own
set noshowmode

" Allow mouse usage.
"   In addition to allowing clicking and scrolling:
" - Support mouse-enabled motions: left-click to place the cursor. Type 'y'
"   then left-click to yank from current cursor to where you next clicked.
" - Drag the status-line or vertical separator to resize
" - Double-click to select word; triple-click for line
set mouse=a

" Color the current line in insert mode and remove color when leaving insert
" mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Display nonprinting characters (tab characters and trailing spaces).
"   Differentiating between tabs and spaces is extremely helpful in tricky
"   debugging situations.
"
"   With these settings <TAB> characters look like >••••.
"
"   Trailing spaces show up as dots like ∙∙∙∙∙.
"
"   The autocmds here mean that we only show the trailing spaces when we're
"   outside of insert mode, so that every space typed doesn't show up as
"   trailing.
"
"   When wrap is off, extends and precedes indicate that there's text offscreen
:autocmd InsertEnter * set listchars=tab:>•
:autocmd InsertLeave * set listchars=tab:>•,trail:∙,nbsp:•,extends:⟩,precedes:⟨

" Format options
"  Changes the behavior of various formatting; see :h formatoptions.
"  Explanation of these options:
"
"    q: gq also formats comments
"    r: insert comment leader after <Enter> in insert mode
"    n: recognize numbered lists
"    1: don't break a line after a 1-letter word
"    c: autoformat comments
"    o: automatically insert comment leader afer 'o' or 'O' in Normal mode.
"       Use Ctrl-u to quickly delete it if you didn't want it.
"    j: where it makes sense, remove a comment leader when joining lines
set formatoptions=qrn1coj

" Open a new buffer without having to save first
set hidden

" Disable swap file creation. Keep enabled for huge files (:set swapfile)
set noswapfile

" Set the working directory to that of the opened file
autocmd BufEnter * silent! lcd %:p:h

" Ignore case when searching...
set ignorecase

" ...unless at least one character is uppercase
set smartcase

" Don't highlight search items by default
set nohlsearch

if has('nvim')
    " When using :s/ to search and replace, this will give a live preview of the
    " proposed changes
    set inccommand=nosplit
endif

" Make tab completion for files/buffers act like bash
set wildmenu

" Show a list when pressing tab; complete first full match
set wildmode=list:full
"
" Ignore these when autocompleting
set wildignore=*.swp,*.bak,*.pyc,*.class

" Always use block cursor. In some terminals and fonts (like iTerm), it can be
" hard to see the cursor when it changes to a line.
set guicursor=i:block

" Enable 24-bit RGB color. Enables things like:
" - ToggleTerm is darker color to better differentiate from text buffter
" - Subtly changes the color of the zenburn colorscheme, including the
"   higlighted line number
set termguicolors

" When termguicolors is set, text highlighted in visual mode has teal
" background. This changes the highlight colour when termguicolors is set to
" be more like when termguicolors is not set
hi Visual guibg=#4a4a4a guifg=none


" ============================================================================
" CUSTOM MAPPINGS
" ============================================================================
"
" Re-map leader from \ to , (comma). Any time <leader> is used below, it now
" means comma.
let mapleader=","

" <leader>H to toggle search highlight
noremap <leader>H :set hlsearch!<CR>

" <leader>W to clean up trailing whitespace in entire file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" <leader>R to refresh syntax highlighting
noremap <leader>R <Esc>:syntax sync fromstart<CR>
inoremap <leader>R <C-o>:syntax sync fromstart<CR>

" <leader>` (backtick) creates a new fenced RMarkdown code block, ready to
" type in. This works in insert or normal mode.
noremap <leader>` i```{r}<CR>```<Esc>O
inoremap <leader>` <C-o>i```{r}<CR>```<Esc>O

" @l will 'listify', surrounding with quotes and adding a trailing comma. Used
" for easily making Python lists out of pasted text.
let @l = "I'A',j"

" <leader>ts to insert timestamp. Useful when writing logs
inoremap <leader>ts <Esc>o<Esc>:r! date "+[\%Y-\%m-\%d \%H:\%M] "<CR>A
noremap <leader>ts <Esc>o<Esc>:r! date "+[\%Y-\%m-\%d \%H:\%M] "<CR>A

" <leader>d to insert a ReST-formatted title for today's date. Only works in
" ReST files.
autocmd FileType rst inoremap <leader>d <Esc>:r! date "+\%Y-\%m-\%d"<CR>A<CR>----------<CR>
autocmd FileType rst noremap  <leader>d <Esc>:r! date "+\%Y-\%m-\%d"<CR>A<CR>----------<CR><Esc>

" <leader>d to insert a Markdown header for today's date. Only works in markdown files.
autocmd FileType markdown inoremap <leader>d <Esc>:r! date "+\# \%Y-\%m-\%d"<CR>A
autocmd FileType markdown noremap  <leader>d <Esc>:r! date "+\# \%Y-\%m-\%d"<CR>A

" <leader>- to fill the rest of the line with dashes
nnoremap <leader>- 80A-<Esc>d80<bar>

" <leader>md to hard-wrap at 80 columns and reformat paragraphs as they are
" written. Mnemonic is md = 'markdown', a common filetype where this is useful
nnoremap <leader>md :set tw=80 fo+=ta<CR>

" <leader>nd to unset the hard-wrap. Mnemonic is 'not markdown', to indicate
" the opposite of the ,md above.
nnoremap <leader>nd :set tw=80 fo-=ta<CR>

" <leader> <TAB> for slightly saner behavior with long TSV lines. Leaves the
" cursor in the command bar so you can type in an appropriate tab stop value.
" Mnemonic of <tab> should be self-explanatory!
nnoremap <leader><tab> :set nowrap tabstop=

" <leader>r to toggle relative numbering -- useful for choosing how many lines
" to delete, for example.
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc
nnoremap <leader>r :call NumberToggle()<cr>

" ----------------------------------------------------------------------------
" Buffer switching
" ----------------------------------------------------------------------------
" buffer switching
" <leader>1 go to buffer 1
" <leader>2 go to buffer 2
" etc
nnoremap <leader>1 :1b<CR>
nnoremap <leader>2 :2b<CR>
nnoremap <leader>3 :3b<CR>
nnoremap <leader>4 :4b<CR>
nnoremap <leader>5 :5b<CR>
nnoremap <leader>6 :6b<CR>
nnoremap <leader>7 :7b<CR>
nnoremap <leader>8 :8b<CR>
nnoremap <leader>9 :9b<CR>

" ----------------------------------------------------------------------------
" Copy/paste
" ----------------------------------------------------------------------------
" Yank/paste to the OS clipboard with ,y and ,p
nmap <leader>y "+y
nmap <leader>Y "+yq
nmap <leader>p "+p
nmap <leader>P "+P

" ----------------------------------------------------------------------------
"  Window navigation
" ----------------------------------------------------------------------------
" ,h ,j ,k and ,l to navigate windows
noremap <silent> ,h :wincmd h<cr>
noremap <silent> ,j :wincmd j<cr>
noremap <silent> ,k :wincmd k<cr>
noremap <silent> ,l :wincmd l<cr>

" <leader>q and <leader>w move to left and right windows respectively. Useful
" when working with a terminal.
" <leader>q will go back to text buffer even in insert mode in a terminal
" buffer.
noremap <silent> ,w :wincmd l<cr>
noremap <silent> ,q :wincmd h<cr>
tnoremap <silent> ,q <C-\><C-n>:wincmd h<cr>


" ----------------------------------------------------------------------------
" Filetype-specific settings
" ----------------------------------------------------------------------------
" Disable tab visibility for other filetypes that don't care
autocmd! FileType html,xml set listchars-=tab:>.

" Override the shiftwidth and tabstops for some file types
autocmd! FileType yaml,yml,r,rmarkdown,*.Rmd,*.rmd set shiftwidth=2 tabstop=2

" Consider any files with these names to be Python
au BufRead,BufNewFile Snakefile,*.snakefile,*.smk setfiletype python


" ============================================================================
" PLUGIN SETTINGS AND MAPPINGS
" ============================================================================
"
" ----------------------------------------------------------------------------
" python-syntax
" ----------------------------------------------------------------------------
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1


" ----------------------------------------------------------------------------
" NERDTree
" ----------------------------------------------------------------------------
" ,n to toggle NERDTree window
nnoremap <leader>n :NERDTreeToggle<cr>

" ----------------------------------------------------------------------------
" ToggleTerm
" ----------------------------------------------------------------------------
" ,t to open a terminal to the right (ToggleTerm)
nmap <leader>t :ToggleTerm direction=vertical<CR>

" When in a terminal, by default Esc does not go back to normal mode and
" instead you need to use Ctrl-\ Ctrl-n. That's pretty awkward; this remaps to
" use Esc.
tnoremap <Esc> <C-\><C-n>

" ,gxx to send current line to terminal
nmap gxx :ToggleTermSendCurrentLine<CR><CR>

" ,gx to send current selection (line or visual) to terminal
xmap gx :ToggleTermSendVisualSelection<CR><CR>

" ,k to render the current RMarkdown file to HTML (named after the current file)
:autocmd FileType rmarkdown nmap <leader>k :TermExec cmd='rmarkdown::render("%:p")'<CR>

" ,k to run the file in IPython when working in Python.
:autocmd FileType python nmap <leader>k :TermExec cmd='run %:p'<CR>

" ,cd to send RMarkdown code chunk and move to the next one.
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

" ,yr to add commonly-used YAML front matter to RMarkdown documents. Mnemonic is
" 'YAML for RMarkdown'. It adds this:
"
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

" ,ko to insert a knitr global options chunk. Mnemonic is 'knitr options'
nmap <leader>ko i<CR>```{r}<CR>knitr::opts_chunk$set(warning=FALSE, message=FALSE)<CR>```<CR><Esc>0


" ----------------------------------------------------------------------------
" vim-airline
" ----------------------------------------------------------------------------
" Enable the display of open buffers along the top, in neovim you can click
" on them to select or use ,1 ,2 ,3 etc to switch to them. See :help
" airline-tabline for more.
let g:airline#extensions#tabline#enabled = 1

" Show the buffer number next to the filename for easier switching. See :help
" airline-tabline for more.
let g:airline#extensions#tabline#buffer_nr_show = 1

" When showing buffers in the top bufferline, show only the filename and not
" the full path. See :help filename-modifiers for more info.
let g:airline#extensions#tabline#fnamemod = ':t'

" See https://github.com/vim-airline/vim-airline/wiki/Screenshots to choose
" other themes, and use :AirlineTheme <themename> to test live.
let g:airline_theme = "ayu_dark"

" If you are using a powerline-enabled font in your terminal application, set
" this to 1. Otherwise set to 0. See :help airline-configuration for more.
let g:airline_powerline_fonts = 1


" ----------------------------------------------------------------------------
" vim-pandoc and vim-pandoc-syntax
" ----------------------------------------------------------------------------
" By default, keep spell-check off. Turn on with `set spell`
let g:pandoc#spell#enabled = 0

" Disable the conversion of ``` to lambda and other fancy
" concealment/conversion that ends up confusing me
let g:pandoc#syntax#conceal#use = 0

" RMarkdown code blocks can be folded too
let g:pandoc#folding#fold_fenced_codeblocks = 1


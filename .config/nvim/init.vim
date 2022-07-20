call plug#begin()

" PLUGIN SETTINGS section.
"
Plug 'vim-scripts/vis'                    " Operations in visual block mode respect selection
Plug 'preservim/nerdcommenter'            " Comment large blocks of text
Plug 'preservim/nerdtree'                 " File browser for vim <Leader>n
Plug 'vim-airline/vim-airline'            " Nice statusline. Install powerline fonts for full effect.
Plug 'vim-airline/vim-airline-themes'     " Themes for the statusline
Plug 'roxma/vim-tmux-clipboard'           " Copy yanked text from vim into tmux's clipboard and vice versa.
Plug 'tmux-plugins/vim-tmux-focus-events' " Makes tmux and vim play nicer together.
Plug 'vim-python/python-syntax'           " Sophisticated python syntax highlighting.
Plug 'Vimjas/vim-python-pep8-indent'      " Indent python using pep8 recommendations
Plug 'ervandew/supertab'                  " Autocomplete most things
Plug 'tpope/vim-fugitive'                 " Run git from vim
Plug 'chrisbra/vim-diff-enhanced'         " Provides additional diff algorithms
Plug 'kassio/neoterm'                     " Provides a separate terminal in vim <Leader>t
Plug 'flazz/vim-colorschemes'             " Pile 'o colorschemes
Plug 'felixhummel/setcolors.vim'          " Easily set colorschemes
Plug 'vim-pandoc/vim-rmarkdown'           " Syntax highlighting for RMarkdown
Plug 'vim-pandoc/vim-pandoc'              " Required for vim-rmarkdown
Plug 'vim-pandoc/vim-pandoc-syntax'       " Required for vim-rmarkdown
Plug 'dhruvasagar/vim-table-mode'         " Very easily make and work with markdown and restructured text tables
Plug 'tmhedberg/SimpylFold'               " Nice folding for Python
Plug 'junegunn/gv.vim'                    " Easily view and browse git history
Plug 'samoshkin/vim-mergetool'            " Makes 3-way merge conflicts easier by only focusing on what needs to be manually edited
Plug 'snakemake/snakemake', {'rtp': 'misc/vim', 'branch': 'main'} " Snakemake syntax and folding
call plug#end()

" ============================================================================
" SETTINGS
" ============================================================================
" ----------------------------------------------------------------------------
" Syntax and file types
" ----------------------------------------------------------------------------
syntax on                      " Syntax highlighting; also does an implicit filetype on
filetype plugin indent on      " Enable detection, plugin , and indent for filetype
set backspace=indent,eol,start " This gets backspace to work in some situations

" ----------------------------------------------------------------------------
" Python-specific indentation handling. Use these by default.
" ----------------------------------------------------------------------------
set foldlevel=99  " go deep
set autoindent    " maintain indentation from prev line
set tabstop=4     " number of spaces <Tab> represents.  For Python.
set shiftwidth=4  " number of spaces for indentation.  Same as tabstop. For Python.
set smarttab      " at the beginning of the line, insert spaces according to shiftwidth
set expandtab     " <Tab> inserts spaces, not '\t'

" ----------------------------------------------------------------------------
" Visual display settings
" ----------------------------------------------------------------------------
colorscheme zenburn              " colorscheme to use
set scrolloff=3                  " keep some lines above and below the cursor to keep context visible
set list                         " show non-printing chars
set showmatch                    " show matching parentheses
set nu                           " display line numbers
set wrap                         " wrap lines
set noshowmode                   " for use with vim-airline, which has its own
set mouse=a                      " allow mouse usage
set encoding=utf-8               " default encoding
:autocmd InsertEnter * set cul   " color the current line in insert mode
:autocmd InsertLeave * set nocul " remove color when leaving insert mode

" Display nonprinting characters
" <TAB> characters become >...
" Trailing spaces show up as dots
" When wrap is off, extends and precedes indicate that there's text offscreen
" The autocmds here only show the trailing spaces when we're outside of insert
" mode, so that every space typed doesn't show up as trailing.
:autocmd InsertEnter * set listchars=tab:>.
:autocmd InsertLeave * set listchars=tab:>.,trail:∙,nbsp:•,extends:⟩,precedes:⟨

" ----------------------------------------------------------------------------
" Format options
" ----------------------------------------------------------------------------
set formatoptions=qrn1c   " q: gq also formats comments
                          " r: insert comment leader after <Enter> in insert mode
                          " n: recognize numbered lists
                          " 1: don't break a line after a 1-letter word
                          " c: autoformat comments

" ----------------------------------------------------------------------------
" General behavior
" ----------------------------------------------------------------------------
set hidden           " open a new buffer without having to save first
set history=1000     " remember more commands and search history
set undolevels=1000  " use many levels of undo
set noswapfile       " disable swap file creation. Keep enabled for huge files

" ----------------------------------------------------------------------------
" Searching
" ----------------------------------------------------------------------------
set ignorecase  " ignore case when searching...
set smartcase   " ...unless at least one character is uppercase
set nohlsearch  " don't highlight search items by default

" ----------------------------------------------------------------------------
" Tab completion settings
" ----------------------------------------------------------------------------
set wildmenu            " make tab completion for files/buffers act like bash
set wildmode=list:full  " show a list when pressing tab; complete first full match
set wildignore=*.swp,*.bak,*.pyc,*.class  " ignore these when autocompleting

set inccommand=nosplit  " when using :s/ to search and replace, this will give
                        " a live preview of the proposed changes

" ============================================================================
" CUSTOM MAPPINGS
" ============================================================================

" re-map mapleader from \ to ,
let mapleader=","

" Toggle search highlight
noremap <Leader>H :set hlsearch!<CR>

" Helper for pep8: cleans up trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Refresh syntax highlighting
noremap <leader>R <Esc>:syntax sync fromstart<CR>
inoremap <leader>R <C-o>:syntax sync fromstart<CR>

" When editing RMarkdown, <leader>` creates a new fenced code block, ready to
" type in. This works in insert or normal mode.
noremap <leader>` i```{r}<CR>```<Esc>O
inoremap <leader>` <C-o>i```{r}<CR>```<Esc>O

" 'Listify': for easily making Python lists out of pasted text.
let @l = "I'A',j"

" Set the working directory to that of the opened file
autocmd BufEnter * silent! lcd %:p:h

" Insert an ReST-formatted title for today's date
inoremap <leader>d <Esc>:r! date "+\%Y-\%m-\%d"<CR>A<CR>----------<CR>
noremap <leader>d <Esc>:r! date "+\%Y-\%m-\%d"<CR>A<CR>----------<CR><Esc>

" Fill the rest of the line with dashes
nnoremap <leader>- 80A-<Esc>d80<bar>

" Hard-wrap at 80 columns. Mnemonic is md = 'markdown', a common filetype where
" this is useful
nnoremap <leader>md :set tw=80 fo+=t<CR>

" Unset the hard-wrap. Mnemonic is 'not markdown', to indicate the opposite of
" the ,md above.
nnoremap <leader>nd :set tw=80 fo-=t<CR>

" Slightly saner behavior with long TSV lines. Leaves the cursor in the command
" bar so you can type in an appropriate tab stop value. Mnemonic of <tab> should
" be self-explanatory!
nnoremap <leader><tab> :set nowrap tabstop=

" ----------------------------------------------------------------------------
" Buffer switching
" ----------------------------------------------------------------------------
" buffer switching
" ,l       : list buffers
" ,b ,f ,g : go back/forward/last-used
" ,1 ,2 ,3 : go to buffer 1/2/3 etc
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>

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
noremap <silent> ,h :wincmd h<cr>
noremap <silent> ,j :wincmd j<cr>
noremap <silent> ,k :wincmd k<cr>
noremap <silent> ,l :wincmd l<cr>

noremap <silent> ,w :wincmd l<cr>
noremap <silent> ,q :wincmd h<cr>

" The above mppings for ,w and ,q to move between windows requires being in
" Normal mode first. The following commands let you use Alt-w and Alt-q to
" switch -- even while in Insert mode.
noremap <M-w> <Esc>:wincmd l<CR>
inoremap <M-w> <Esc>:wincmd l<CR>

tnoremap <M-q> <C-\><C-n>:wincmd h<CR>


" ============================================================================
" FILE-TYPE SPECIFIC SETTINGS
" ============================================================================
autocmd! FileType html,xml set listchars-=tab:>. " disable tabs for other filetypes that don't care
autocmd! FileType yaml,yml set shiftwidth=2 tabstop=2
autocmd! FileType r,rmarkdown set shiftwidth=2 tabstop=2

" Consider any files with these names to be Python
au BufRead,BufNewFile Snakefile setfiletype python
au BufRead,BufNewFile *.snakefile setfiletype python

" ============================================================================
" RELATIVE NUMBERING
" ============================================================================
" Relative numbering. Use <Leader>r to turn on relative line numbering --
" useful for choosing how many lines to delete, for example.
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc
nnoremap <leader>r :call NumberToggle()<cr>

" ============================================================================
" PLUGIN SETTINGS AND MAPPINGS
" Settings that require particular plugins to be installed. Grouped by plugin.
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
" Toggle NERDTree window
nnoremap <leader>n :NERDTreeToggle<cr>

" ----------------------------------------------------------------------------
" neoterm
" ----------------------------------------------------------------------------
" Open a terminal to the right (neoterm plugin)
nmap <Leader>t :vert rightb Tnew<CR>

" In many cases we have a conda environment nearby named 'env', here are some
" easy ways to open a terminal and activate it.
nmap <Leader>te :vert rightb Tnew<CR>:wincmd l<CR>source activate ./env<CR>
nmap <Leader>t1e :vert rightb Tnew<CR>:wincmd l<CR>source activate ../env<CR>
nmap <Leader>t2e :vert rightb Tnew<CR>:wincmd l<CR>source activate ../../env<CR>
nmap <Leader>t3e :vert rightb Tnew<CR>:wincmd l<CR>source activate ../../../env<CR>


" When in a terminal, by default Esc does not go back to normal mode and
" instead you need to use Ctrl-\ Ctrl-n. This remaps to use Esc.
tnoremap <Esc> <C-\><C-n>

" Any time a terminal is entered, go directly into Insert mode. This makes it
" behave a little more like a typical terminal.
:au BufEnter,FocusGained,BufWinEnter,WinEnter * if &buftype == 'terminal' | :startinsert | endif
:au BufLeave,FocusLost,BufWinLeave,WinLeave * if &buftype == 'terminal' | :stopinsert | endif

" The above autocommand triggers a bug so we need a workaround.
"
" There's a Vim and NeoVim bug where terminal buffers don't respect the
" autocmd when using the mouse to enter a buffer. Based on the following
" comment in the neovim repo, the workaround is to disable left mouse release,
" specifically in the terminal buffer (!)
" https://github.com/neovim/neovim/issues/9483#issuecomment-461865773
tmap <LeftRelease> <Nop>

" Send text to open neoterm terminal (neoterm plugin)
nmap gx <Plug>(neoterm-repl-send)<CR>

" Send selection, and go to the terminal in insert mode
xmap gx <Plug>(neoterm-repl-send)`><CR>
nmap gxx <Plug>(neoterm-repl-send-line)<CR>

" Render the current RMarkdown file to HTML (named after the current file)
:autocmd FileType rmarkdown nmap <Leader>k :T rmarkdown::render("%")<CR>

" Use the same mnemonic when working in IPython
:autocmd FileType python nmap <Leader>k :T run %<CR>

" Have Neoterm scroll to the end of its buffer after running a command
let g:neoterm_autoscroll = 1

" Let the user determine what REPL to load
let g:neoterm_auto_repl_cmd = 0

" Send RMarkdown code chunk.
"
" When inside a code chunk, <Leader>cd selects the chunk and sends to neoterm.
" Breaking this down...
"
" /```{<CR>                       -> search for chunk delimiter (recall <CR> is Enter)
" N                               -> find the *previous* match to ```{
" j                               -> move down one line from the previous match
" V                               -> enter visual line-select mode
" /^```\n<CR>                     -> select until the next chunk delimiter by itself on the line (which should be the end)
" k                               -> go up one line from that match so we don't include that line
" <Plug>(neoterm-repl-send)<CR>   -> send the selection to the neoterm terminal
" /```{r<CR>                      -> go to the start of the next chunk
nmap <Leader>cd /```{<CR>NjV/```\n<CR>k<Plug>(neoterm-repl-send)<CR>/```{r<CR>

" This adds commonly-used YAML front matter to RMarkdown documents
" ---
" output:
"   html_document:
"     code_folding: hide
"     toc: true
"     toc_float: true
"     toc_depth: 3
" ---
nmap <Leader>ry i---<CR>output:<CR>  html_document:<CR>  code_folding: hide<CR>toc: true<CR>toc_float: true<CR>toc_depth: 3<CR><BS>---<Esc>0

" Insert a knitr global options chunk.
nmap <Leader>ko i<CR>```{r}<CR>knitr::opts_chunk$set(warning=FALSE, message=FALSE)<CR>```<CR><Esc>0


" ----------------------------------------------------------------------------
" powerline
" ----------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = "powerlineish"
set laststatus=2
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0

" These might be useful later -- in case you're not using a powerline font
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#tabline#right_sep = ' '
" let g:airline#extensions#tabline#right_alt_sep = '|'
" let g:airline_left_sep = ' '
" let g:airline_left_alt_sep = '|'
" let g:airline_right_sep = ' '
" let g:airline_right_alt_sep = '|'
" let g:airline_theme= 'gruvbox'

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

" Change the working directory of the terminal to be that of the buffer from
" which this is called
nmap <Leader>tcd :T cd "$( dirname % )"<CR>

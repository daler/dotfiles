call plug#begin()

" Plugins come from GitHub. Plug 'username/repo' can be found at
" https://github.com/user/repo.
" These use vim-plug syntax.

Plug 'vim-scripts/vis'                    " Operations in visual block mode respect selection
Plug 'preservim/nerdcommenter'            " Comment large blocks of text
Plug 'preservim/nerdtree'                 " File browser for vim <leader>n
Plug 'vim-airline/vim-airline'            " Nice statusline. Install powerline fonts for full effect.
Plug 'vim-airline/vim-airline-themes'     " Themes for the statusline
Plug 'roxma/vim-tmux-clipboard'           " Copy yanked text from vim into tmux's clipboard and vice versa.
Plug 'tmux-plugins/vim-tmux-focus-events' " Makes tmux and vim play nicer together.
Plug 'vim-python/python-syntax'           " Sophisticated python syntax highlighting.
Plug 'Vimjas/vim-python-pep8-indent'      " Indent python using pep8 recommendations
Plug 'ervandew/supertab'                  " Autocomplete most things
Plug 'tpope/vim-fugitive'                 " Run git from vim
Plug 'chrisbra/vim-diff-enhanced'         " Provides additional diff algorithms
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
Plug 'ggandor/leap.nvim'                  " Jump around in a buffer with low mental effort
Plug 'tpope/vim-surround'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
call plug#end()

lua require('leap').set_default_keymaps()

" ============================================================================
" LUA SETUP
" ============================================================================
" The 'lua' command runs a line of Lua.
" The 'lua <<EOF .... EOF' syntax embeds Lua in this vimscript file.

lua <<EOF
-- Some Lua packages need to have their setup() function run.
-- Override the ToggleTerm setting for vertical split terminal
require('toggleterm').setup{
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end
}

EOF

" ============================================================================
" SETTINGS
" ============================================================================
" Syntax highlighting; also does an implicit filetype on
syntax on

" Enable detection, plugin , and indent for filetype
filetype plugin indent on

" This gets backspace to work in some situations
set backspace=indent,eol,start

" ----------------------------------------------------------------------------
" Python-specific indentation handling. Use these by default.
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Visual display settings
" ----------------------------------------------------------------------------
colorscheme zenburn              " colorscheme to use
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
" - Mouse-enabled motions: left-click to place the cursor. Type 'y' then
"   left-click to yank from current cursor to where you next clicked.
" - Drag the status-line or vertical separator to resize
" - Double-click to select word; triple-click for line
set mouse=a

" Color the current line in insert mode
:autocmd InsertEnter * set cul

" Remove color when leaving insert mode
:autocmd InsertLeave * set nocul

" ----------------------------------------------------------------------------
" Display nonprinting characters (tab characters and trailing spaces)
" ----------------------------------------------------------------------------
" Differentiating between tabs and spaces is extremely helpful in tricky
" debugging situations.
"
" With these settings <TAB> characters look like >••••.
"
" Trailing spaces show up as dots like ∙∙∙∙∙.
"
" The autocmds here mean that we only show the trailing spaces when we're
" outside of insert mode, so that every space typed doesn't show up as
" trailing.
"
" When wrap is off, extends and precedes indicate that there's text offscreen
:autocmd InsertEnter * set listchars=tab:>•
:autocmd InsertLeave * set listchars=tab:>•,trail:∙,nbsp:•,extends:⟩,precedes:⟨

" ----------------------------------------------------------------------------
" Format options
" ----------------------------------------------------------------------------
"  Changes the behavior of various formatting
"  See :h formatoptions
set formatoptions=qrn1coj
" q: gq also formats comments
" r: insert comment leader after <Enter> in insert mode
" n: recognize numbered lists
" 1: don't break a line after a 1-letter word
" c: autoformat comments
" o: automatically insert comment leader afer 'o' or 'O' in Normal mode.
"    Use Ctrl-u to quickly delete it if you didn't want it.
" j: where it makes sense, remove a comment leader when joining lines

" ----------------------------------------------------------------------------
" General behavior
" ----------------------------------------------------------------------------
" Open a new buffer without having to save first
set hidden

" Disable swap file creation. Keep enabled for huge files (:set swapfile)
set noswapfile


" ----------------------------------------------------------------------------
" Searching
" ----------------------------------------------------------------------------
" Ignore case when searching...
set ignorecase

" ...unless at least one character is uppercase
set smartcase

" Don't highlight search items by default
set nohlsearch

" ----------------------------------------------------------------------------
" Tab completion settings
" ----------------------------------------------------------------------------
" Make tab completion for files/buffers act like bash
set wildmenu

" Show a list when pressing tab; complete first full match
set wildmode=list:full
"
" Ignore these when autocompleting
set wildignore=*.swp,*.bak,*.pyc,*.class

set inccommand=nosplit  " when using :s/ to search and replace, this will give
                        " a live preview of the proposed changes

" ============================================================================
" CUSTOM MAPPINGS
" ============================================================================

" re-map mapleader from \ to ,
let mapleader=","

" ,H to toggle search highlight
noremap <leader>H :set hlsearch!<CR>

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

" Insert timestamp. Useful when writing logs
inoremap <leader>dt <Esc>o<Esc>:r! date "+[\%Y-\%m-\%d \%H:\%M] "<CR>A
noremap <leader>dt <Esc>o<Esc>:r! date "+[\%Y-\%m-\%d \%H:\%M] "<CR>A

" Insert an ReST-formatted title for today's date
autocmd FileType rst inoremap <leader>d <Esc>:r! date "+\%Y-\%m-\%d"<CR>A<CR>----------<CR>
autocmd FileType rst noremap  <leader>d <Esc>:r! date "+\%Y-\%m-\%d"<CR>A<CR>----------<CR><Esc>

" Same, but markdown header
autocmd FileType markdown inoremap <leader>d <Esc>:r! date "+\# \%Y-\%m-\%d"<CR>A
autocmd FileType markdown noremap  <leader>d <Esc>:r! date "+\# \%Y-\%m-\%d"<CR>A


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
noremap <silent> ,h :wincmd h<cr>
noremap <silent> ,j :wincmd j<cr>
noremap <silent> ,k :wincmd k<cr>
noremap <silent> ,l :wincmd l<cr>

" ,q and ,w move to left and right windows respectively. Useful when working
" with a terminal. ,q will go back to text buffer even in insert mode in
" a terminal buffer. Can be more ergonomic than ,h and ,l defined above.
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
" ,r to enable relative numbering -- useful for choosing how many lines to
" delete, for example.
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
" ToggleTerm
" ----------------------------------------------------------------------------

" In many cases we have a conda environment nearby named 'env', here are some
" easy ways to open a terminal and activate it.
nmap <Leader>te :vert rightb Tnew<CR>:wincmd l<CR>source activate ./env<CR>
nmap <Leader>t1e :vert rightb Tnew<CR>:wincmd l<CR>source activate ../env<CR>
nmap <Leader>t2e :vert rightb Tnew<CR>:wincmd l<CR>source activate ../../env<CR>
nmap <Leader>t3e :vert rightb Tnew<CR>:wincmd l<CR>source activate ../../../env<CR>

" ,t to open a terminal to the right (ToggleTerm)
nmap <leader>t :ToggleTerm direction=vertical<CR>

" When in a terminal, by default Esc does not go back to normal mode and
" instead you need to use Ctrl-\ Ctrl-n. That's pretty awkward; this remaps to
" use Esc.
tnoremap <Esc> <C-\><C-n>

" ,gxx to send current line to terminal
nmap gxx :ToggleTermSendCurrentLine<CR>

" ,gx to send current selection (line or visual) to terminal
xmap gx :ToggleTermSendVisualSelection<CR>

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
nmap <Leader>ry i---<CR>output:<CR>  html_document:<CR>  code_folding: hide<CR>toc: true<CR>toc_float: true<CR>toc_depth: 3<CR><BS>---<Esc>0

" ,ko to insert a knitr global options chunk. Mnemonic is 'knitr options'
nmap <leader>ko i<CR>```{r}<CR>knitr::opts_chunk$set(warning=FALSE, message=FALSE)<CR>```<CR><Esc>0


" ----------------------------------------------------------------------------
" powerline
" ----------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = "powerlineish"
set laststatus=2
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0

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

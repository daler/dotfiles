if !has('nvim')
    set nocompatible
    execute pathogen#infect()
endif

if has('nvim')
    call plug#begin('~/.local/share/nvim/site/autoload')
    "Plug 'fholgado/minibufexpl.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'justincampbell/vim-eighties'
    Plug 'godlygeek/tabular'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'tpope/vim-surround'
    Plug 'jalvesaq/Nvim-R'
    Plug 'roxma/vim-tmux-clipboard'
    Plug 'vim-scripts/indentpython.vim'
    Plug 'tmux-plugins/vim-tmux-focus-events'
    Plug 'nvie/vim-flake8'
    Plug 'kien/rainbow_parentheses.vim'
    call plug#end()
endif

let mapleader=","   " re-map mapleader from \ to ,

autocmd FileType python map <buffer> <leader>8 :call Flake8()<CR>

" CtrlP shortcuts
" open file menu
nnoremap <Leader>o :CtrlP<CR>
" open buffer menu
nnoremap <Leader>b :CtrlPBuffer<CR>
" open most recently used files
nnoremap <Leader>f :CtrlPMRUFiles<CR>


" 'listify' -- surround line with quotes, add a trailing comma, and move to the
" next line.
let @l = "I'A',j"

" Set the working directory to that of the opened file
autocmd BufEnter * silent! lcd %:p:h

" Syntax and file types
syntax on                 " syntax highlighting; also does an implicit filetype on
filetype plugin indent on " enable detection, plugin , and indent for filetype
set backspace=indent,eol,start


" Python-specific indentation handling
set foldmethod=indent     " maybe 'syntax' would work for python?
set foldlevel=99          " go deep
set autoindent            " maintain indentation from prev line
set tabstop=4             " number of spaces <Tab> represents.  For Python.
set shiftwidth=4          " number of spaces for indentation.  Same as tabstop. For Python.
set smarttab              " at the beginning of the line, insert spaces according to shiftwidth


" Visual display settings
set scrolloff=3           " keep some lines above and below the cursor to keep context visible
set list                  " show non-printing chars
set listchars=tab:>.,trail:.,extends:#,nbsp:.  " how to display nonprinting chars
set showmatch             " show matching parentheses
set nu                    " display line numbers
set wrap                  " wrap lines
set noshowmode            " for use with vim-airline, which has its own
set mouse=a
set encoding=utf-8
colorscheme zenburn

" Format options, with description
set formatoptions=qrn1c   " q: gq formats comments
                          " r: insert comment leader after <Enter> in insert mode
                          " n: recognize numbered lists
                          " 1: don't break a line after a 1-letter word
                          " c: autoformat comments

" General behavior
set hidden                " open a new buffer without having to save first
set history=1000          " remember more commands and search history
set undolevels=1000       " use many levels of undo
set noswapfile            " disable swap file creation.  Keep enabled for huge files


" Searching
set ignorecase            " ignore case when searching
set smartcase             " unless at least one character is uppercase
set nohlsearch            " highlight search items

" tab completion settings
set wildmenu              " make tab completion for files/buffers act like bash
set wildmode=list:full    " show a list when pressing tab; complete first full match
set wildignore=*.swp,*.bak,*.pyc,*.class  " ignore these when autocompleting


" autocmd settings to override in a filetype-specific manner
autocmd filetype python,sh,bash,snakemake set expandtab " expand <Tab> key presses to spaces, but only for Python
autocmd filetype html,xml set listchars-=tab:>. " disable tabs for other filetypes that don't care
autocmd filetype yaml,yml set shiftwidth=2 tabstop=2

" R-specific. When writing R scripts to be converted via knitr::spin to
" Rmd/HTML, comments start with #'
autocmd FileType r set comments=b:#



" Relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

" Toggle between normal and relative numbering.
nnoremap <leader>r :call NumberToggle()<cr>
nnoremap <leader>n :NERDTreeToggle<cr>

" plugin settings
let python_highlight_all = 1 " for python.vim; syntax highlight all available/known syntax

" =============================================================================
" <leader> commands
"

" PEP8 pluging settings.  ,8 to run pep8 check
let g:pep8_map='<leader>8'
let g:pep8_ignore="E121"


" Helper for pep8: ,W cleans up trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>


" F12 to refresh syntax highlighting
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" buffer switching -- up to 8, cause PEP8 is <leader>8
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


" Yank/paste to the OS clipboard with ,y and ,p
nmap <leader>y "+y
nmap <leader>Y "+yq
nmap <leader>p "+p
nmap <leader>P "+P



"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup



" color line in insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul


" highlight cursorline ctermbg=gray cterm=NONE


let R_vsplit = 1  " nvim-r puts the console on the right with <LocalLeader>rf
let rout_follow_colorscheme = 1
let R_assign = 3  " nvim-r replaces ' __ ' with ' <- '
let R_nvimpager = "horizontal"
let R_objbr_place = "console,bottom"


function! RMakeHTML_2(t)
   update
   let rmddir = expand("%:p:h")
   let rcmd = 'nvim.interlace.rmd("' . expand("%:t") . '", outform = "' . a:t .'", rmddir = "' . rmddir . '"'
   let rcmd .= ", view = FALSE"
   let rcmd = rcmd . ', envir = ' . g:R_rmd_environment . ')'
   call g:SendCmdToR(rcmd)
endfunction

function! RMakeHTML_3()
   update
   let rmddir = expand("%:p:h")
   let rcmd = 'nvim.interlace.rmd("' . expand("%:t") . '", outform = "' . a:t .'", rmddir = "' . rmddir . '"'
   let rcmd .= ", view = FALSE"
   let rcmd = rcmd . ', envir = ' . g:R_rmd_environment . ')'
   call g:SendCmdToR(rcmd)
endfunction
"bind RMakeHTML_2 to leader kk
nnoremap <silent> <LocalLeader>kb :call RMakeHTML_2("knitrBootstrap::bootstrap_document")<CR>
nnoremap <silent> <LocalLeader>kk :call RMakeHTML_2("html_document")<CR>
nnoremap <silent> <LocalLeader>km :!mv %:r.html ../output/<CR>


"Better window navigation
noremap <silent> ,h :wincmd h<cr>
noremap <silent> ,j :wincmd j<cr>
noremap <silent> ,k :wincmd k<cr>
noremap <silent> ,l :wincmd l<cr>

noremap <silent> ,w :wincmd l<cr>A
noremap <silent> ,q :wincmd h<cr>

let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = "powerlineish"
set laststatus=2
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0

set clipboard=unnamed

" These might be useful later -- in case you're not using a powerline font
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#tabline#right_sep = ' '
" let g:airline#extensions#tabline#right_alt_sep = '|'
" let g:airline_left_sep = ' '
" let g:airline_left_alt_sep = '|'
" let g:airline_right_sep = ' '
" let g:airline_right_alt_sep = '|'
"let g:airline_theme= 'gruvbox'

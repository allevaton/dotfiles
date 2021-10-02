filetype plugin indent on
syntax on

" This is the key that will define how remaps essentially work.
let mapleader=','

"""""""""""""""""" Base Settings: """"""""""""""""""
set autoindent      " Always
set copyindent      " Copy the previous indentation
set expandtab       " Much easier when everything's a space
set shiftround      " Only multiples of 4 for shifting
set shiftwidth=2    " Auto indenting spaces
set smarttab        " Go by shift width, not tab stop
set softtabstop=2   " Treats 4 spaces as tabs
set tabstop=2       " Tab size of 4 is better

set backspace=indent,eol,start " Backspace over everything
set gdefault        " search/replace globally on a line by default
set hidden          " Hide buffers instead of closing them.
set history=2000    " keep 2000 lines of command line history
set hlsearch        " Highlight search terms (:noh stops highlight)
set ignorecase      " ignore case sensitivity when searching
set incsearch       " do incremental searching
set laststatus=2    " Always show the status bar
set noautochdir     " DO NOT automatically adjust the current directory for the file
set nobackup        " don't keep a backup file
set noswapfile      " Who uses these, anyways?
set ruler           " show the cursor position all the time
set scrolloff=4     " Use a 4 line buffer when scrolling
set showcmd         " display incomplete commands
set showmatch       " Parenthetical matching
set showmode        " Always show the mode we're in
set sidescrolloff=2 " Side scrolling
set smartcase       " ignore case if pattern is all lower

" Folding:
set foldenable      " enable folding
set foldlevelstart=99 " start with everything folded
set foldmethod=marker " user markers for folding
"set foldmethod=manual " manual folding
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
" which comments trigger auto-unfold

set viminfo='10,\"100,:20,%,n~/.viminfo

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

set formatoptions=tcroqn " see :help fo-table
set wildmode=longest,list,full
set wildmenu
set modeline

set number
"set relativenumber " Relative numbers

" wildcard ignores
set wildignore=*.pyc,*.pyo,*.so,*.swp,*/tmp/*

set linebreak       " disable line breaks for better word wrapping
set nolist          " no lists also disable line breaks
set wrap            " word wrapping

nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Significantly better navigation
nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$

" What an awesome idea
nnoremap ; :
nnoremap <leader>; ;

" Spelling is useful
nnoremap <leader>s :set spell!<CR>

" jj changes insert->normal
inoremap jj <esc>

" And some nice page up and down remakes
nnoremap <S-k> <C-u>
nnoremap <S-j> <C-d>


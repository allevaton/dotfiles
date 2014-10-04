" My vimrc
"
" Maintainer:   Nick Allevato
"
" When started as "evim", evim.Vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Let's begin
set nocompatible
filetype off

set rtp=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
set rtp+=$HOME/.vim/bundle/Vundle.vim

" In case we're on Windows
let $MYVIMRC='$HOME/.vimrc'

call vundle#begin()

" Begin Plugins:
Plugin 'gmarik/Vundle.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'chrisbra/csv.vim'
Plugin 'tmhedberg/matchit'
Plugin 'scrooloose/nerdtree'
Plugin 'oblitum/rainbow'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-afterimage'
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'dag/vim-fish'
Plugin 'tpope/vim-fugitive'
Plugin 'jtratner/vim-flavored-markdown'
Plugin 'tfnico/vim-gradle'
Plugin 'gerw/vim-latex-suite'
Plugin 'dbakker/vim-lint'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'Matt-Stevens/vim-systemd-syntax'
Plugin 'tkztmk/vim-vala'
Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'allevaton/vim-luna'

if !has('win32')
    Plugin 'Valloric/YouCompleteMe'
end

call vundle#end()
filetype plugin indent on
syntax on

" Handle for fish
set shell=bash\ --norc

" This is the key that will define how remaps essentially work.
let mapleader=','

""" BULK CONFIGURATION: """
set autoindent      " Always
set backspace=indent,eol,start " Backspace over everything
set copyindent      " Copy the previous indentation
set expandtab       " Much easier when everything's a space
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
set shiftround      " Only multiples of 4 for shifting
set shiftwidth=4    " Auto indenting spaces
set showcmd         " display incomplete commands
set showmatch       " Parenthetical matching
set showmode        " Always show the mode we're in
set sidescrolloff=2 " Side scrolling
set smartcase       " ignore case if pattern is all lower
set smarttab        " Go by shift width, not tab stop
set softtabstop=4   " Treats 4 spaces as tabs
set tabstop=4       " Tab size of 4 is better
                    " Use `<leader>be` to open buffer list
set foldenable      " enable folding
set foldlevelstart=99 " start with everything folded
set foldmethod=marker " user markers for folding
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                    " which comments trigger auto-unfold

set formatoptions=tcroqnj " see :help fo-table
set wildmenu        " make tab completion work like bash
set wildmode=list:full " show a list when pressing tab complete
set modeline

" wildcard ignores
set wildignore=*.pyc,*.pyo,*.so,*.swp

set linebreak       " disable line breaks for better word wrapping
set nolist          " no lists also disable line breaks
set wrap            " word wrapping

" this could add a major typing latency, so be careful.
" if it does, remove THIS LINE
"set regexpengine=1

set encoding=utf-8
set fileencoding=utf-8

" C Family Tags:
"set tags+=~/.vim/tags/cpp,~/.vim/tags/gl,./.tags

" CtrlP Setup:
let g:ctrlp_extensions = ['tag', 'line']

" Dictionary:
"set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

" Rainbow Parentheses:
let g:rainbow_active = 1
" 458748 was cc241d
let g:rainbow_guifgs = [
    \ '#458588',
    \ '#b16286',
    \ '#d65d0e',
    \ '#458748',
    \ '#458588',
    \ '#b16286',
    \ '#d65d0e',
    \ '#458748'
    \ ]

" YCM YouCompleteMe Configuration:
"let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_key_invoke_completion = '<C-x><C-o>'
let g:ycm_key_detailed_diagnostics = '<leader>D'
let g:ycm_auto_trigger = 1

nnoremap <leader>e :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>d :YcmCompleter GoToDefinition<CR>

" Bufexplorer:
let g:bufExplorerShowNoName = 1
let g:bufExplorerSortBy = 'number'

" Column Color Change:
"let &colorcolumn=join(range(80, 255 ), ',')

" Syntastic Config:
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_python_flake8_args = '--select=F,C9 --max-complexity=10'

let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

" Use pylint for non-saving checking because it's much slower
nnoremap <leader>S :SyntasticCheck pylint<CR>

" Eclim:
let g:EclimCompletionMethod = 'omnifunc'

" Omnicompletion:
set completeopt=menu,menuone,longest,preview

" LaTeX:
set grepprg=grep\ -nH\ $*
let g:tex_flavor = 'latex'
let g:Tex_CompileRule_dvi = "latex --interaction=nonstopmode \"$*\""
let g:Tex_CompileRule_pdf = "pdflatex --interaction=nonstopmode \"$*\""
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_ViewRule_pdf = "evince \"$*.pdf\" \&"
let g:Tex_ViewRuleComplete_pdf = "evince \"$*.pdf\" \&"

" Airline:
let g:airline_theme = 'luna'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Tagbar:
"let g:tagbar_left = 0
let g:tagbar_sort = 0

" Python Syntax Config:
let g:python_highlight_builtin_funcs = 1
let g:python_highlight_builtin_objs = 1
let g:python_highlight_exceptions = 1
let g:python_highlight_string_format = 1
let g:python_highlight_string_formatting = 1
let g:python_highlight_string_templates = 1

" NERDTree:
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_gui_startup = 0

" QuickFix Window:
let g:quickfix_is_open = 0

" Quick fix window solution {{{
function! s:QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction
" }}}

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off. {{{
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
        au! auto_highlight
        augroup! auto_highlight
        setl updatetime=4000
        echo 'Highlight current word: OFF'
        return 0
    else
        augroup auto_highlight
            au!
            au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
        augroup end
        setl updatetime=1
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction
" }}}

" ---------------
"
" EasyMotion Settings:
nnoremap ? /
map  <Space>/ <Plug>(easymotion-sn)
omap <Space>/ <Plug>(easymotion-tn)

" Better pasting
xnoremap p "_dP

" define custom leader here
" defaults to <leader><leader>
map <Space> <Plug>(easymotion-prefix)

" These 'n' & 'N' mappings are options. You do not have to map 'n' & 'N' to EasyMotion.
" Without these mappings, 'n' & 'N' works fine. (These mappings just provide
" different highlight method and have some other features)
map <Space>n <Plug>(easymotion-next)
map <Space>N <Plug>(easymotion-prev)

nmap s <Plug>(easymotion-s)
nmap <Space>f <Plug>(easymotion-f)

" Repeat the last motion
map <Space>. <Plug>(easymotion-repeat)

map <Space>l <Plug>(easymotion-lineforward)
map <Space>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0
let g:EasyMotion_smartcase = 1
" ---------------

" Set it so enter on a menu item doesn't insert return
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

" Generate implicit tags (NOT RECOMMENDED)
nnoremap <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Quickfix
nnoremap <leader>1 :call <SID>QuickfixToggle()<cr>

" Better cursor searching
nnoremap # *
nnoremap * #

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" Easier window navigation
" Using this weirdo block will stop vim-latex from remapping C-j
nmap <SID>I_won’t_ever_type_this <Plug>IMAP_JumpForward
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Significantly better navigation
nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$

" Go right to command mode from insert mode
" TODO doesn't work?
inoremap <C-;> <esc>:

" Faster spell checking suggestions
nnoremap zz z=

" What an awesome idea
nnoremap ; :
nnoremap <leader>; ;

" Spelling is useful
nnoremap <leader>s :set spell!<CR>

" Trimming whitespace
"nnoremap <leader>ws :%s/\s\+$<CR>

" jj changes insert->normal
inoremap jj <esc>

" Easy :set nohls!
nnoremap <leader>2 :set nohls!<CR>
nnoremap <leader>h :noh<CR>

" Start NERDTree in the current directory
nmap <leader>n :NERDTreeTabsToggle<CR>

" Open tagbar
nnoremap <leader>t :TagbarToggle<CR>

" Copy
vmap <C-c> y

" Select all
inoremap <C-a> <esc>ggVG

" Switching tabs
nnoremap <C-tab> :bn<CR>
nnoremap <C-S-tab> :bp<CR>
inoremap <C-tab> <esc>:bn<CR>
inoremap <C-S-tab> <esc>:bp<CR>

"nnoremap <Tab> <C-6>

" Allow switching windows in edit mode
inoremap <C-w> <esc><C-w>

" And some nice page up and down remakes
nnoremap <S-k> <C-u>
nnoremap <S-j> <C-d>

" Space opens folds
"nnoremap <Space> a <esc>
"vnoremap <Space> a <esc>
"nnoremap <S-Space> i <esc>
"vnoremap <S-Space> i <esc>

" Deleting words easily
inoremap <C-backspace> <C-w>

" Awesomely navigate warnings
nnoremap <leader>wn :lnext<CR>
nnoremap <leader>wp :lprevious<CR>

" Using '<' and '>' in visual mode to shift code by a tab-width left/right by
" default exits visual mode. With this mapping we remain in visual mode after
" such an operation.
xnoremap < <gv
xnoremap > >gv

" Copying and pasting
if has('win32')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has('autocmd')
    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=79

    " i3 config
    autocmd BufNewFile,BufRead ~/.i3/config set ft=i3

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gVim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
    augroup END

    " Go to the first line of a git commit message
    autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

    " Go to the first line of a diff
    if &diff == 1
        call setpos('.', [0, 1, 1, 0])
    endif

    " Java:
    augroup java
        autocmd Filetype java nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
        autocmd Filetype java nnoremap <silent> <buffer> <leader>d
            \ :JavaDocSearch -x declarations<cr>
        autocmd Filetype java nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
    augroup END

    " Cleaning whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e

    " TODO necessary?
    au FileType python set omnifunc=pythoncomplete#Complete

    " Probably using NASM in Vim
    au BufRead,BufNewFile *.asm set filetype=nasm

    " Close the preview window when we move
    au CursorMovedI * if pumvisible() == 0|silent! pclose|endif

    " Always have rainbow parentheses on
    "au BufNewFile,BufRead * RainbowParenthesesLoadRound
    "au BufNewFile,BufRead * RainbowParenthesesActivate

endif


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" For GUI:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
    syntax on
    " add a fold column
    "set foldcolumn=2

    " Line highlight
    set cul
    set nu

    " GUI Font
    if has("gui_win32")
        set guifont=DejaVu_Sans_Mono_for_Powerline:h12
    else
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
    endif

    " Colorscheme:
    set background=dark
    "colorscheme lucius
    colorscheme luna
    "colorscheme solarized

    " With this, the gui (gVim and macVim) now doesn't have the toolbar,
    " left and right scrollbars, and the menu.
    " From Valloric's vimrc
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    set guioptions-=M
endif

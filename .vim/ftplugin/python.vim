"
"

set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=80

" Do we need this?
set omnifunc=pythoncomplete#Complete

map <leader>i :YcmCompleter GoToInclude<CR>
map <leader>d :YcmCompleter GoTo<CR>
map <C-q> :GetDoc<CR>

"let g:jedi#usages_command = "<C-u>"
"let g:jedi#goto_command = "<leader>d"
"let g:jedi#rename_command = "<leader>r"
"let g:jedi#documentation_command = "<C-q>"

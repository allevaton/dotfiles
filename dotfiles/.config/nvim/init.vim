call plug#begin('~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'github/copilot.vim'

Plug 'lewis6991/gitsigns.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'petertriho/cmp-git'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

Plug 'windwp/nvim-ts-autotag'
Plug 'windwp/nvim-autopairs'

" Replace <CurrentMajor> by the latest released major (first number of latest release)
Plug 'L3MON4D3/LuaSnip', { 'tag': 'v2.*', 'do': 'make install_jsregexp' }
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'leafgarland/typescript-vim'
" Plug 'HerringtonDarkholme/yats.vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

Plug 'christoomey/vim-tmux-navigator'

Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Official nord theme has some major issues with Treesitter
Plug 'shaunsingh/nord.nvim'
" Plug 'nordtheme/vim'

" Plug 'easymotion/vim-easymotion'
" Plug 'tpope/vim-fugitive'
" Plug 'airblade/vim-gitgutter'

" Plug 'rust-lang/rust.vim'
" Plug 'cespare/vim-toml'

Plug 'wfxr/minimap.vim', { 'do': ':!cargo install --locked code-minimap' }

call plug#end()

""" LUA INIT
lua <<EOF
require('nvim-web-devicons').setup {
  default = true
}
require('nvim-ts-autotag').setup {
  opts = {
    -- Defaults
    enable_close = true,          -- Auto close tags
    enable_rename = true,         -- Auto rename pairs of tags
    enable_close_on_slash = true  -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    -- ['html'] = {
    --   enable_close = false
    -- }
  }
}
require('nvim-autopairs').setup {
  disable_filetype = {
    'TelescopePrompt',
    'vim'
  },
}
require('gitsigns').setup {}

-- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),

    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  }),
  sources = cmp.config.sources({
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
}

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})
require('cmp_git').setup {}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   }),
--   matching = { disallow_symbol_nonprefix_matching = false }
-- })

require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = {
    'lua',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',

    'html',
    'javascript',
    'typescript',
    'tsx'
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append('/some/path/to/store/parsers')!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { 'c', 'rust' },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('lualine').setup {
   options = {
    theme = 'nord'
  }
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
-- vim.opt.termguicolors = true

require('nvim-tree').setup {
  sort = {
    sorter = 'case_sensitive',
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
}

require('telescope').setup {
  -- ...
}

local lsp = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.tsserver.setup {
  capabilities = lsp,
  root_dir = function(fname)
    return lspconfig.util.root_pattern('.git')(fname)
        or lspconfig.util.root_pattern('turbo.json', 'package.json', 'tsconfig.json', 'jsconfig.json')(fname)
        or lspconfig.util.path.dirname(fname)
  end,
}

EOF

filetype plugin indent on

"xnoremap p :set paste<CR>"_dP:set nopaste<CR>

" Spaces & Tabs {{{
set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=2    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set smartindent
set copyindent      " copy indent from the previous line
set scrolloff=4
set cursorline
" }}} Spaces & Tabs

" Search {{{
set incsearch       " search as characters are entered
set hlsearch        " highlight matche
set ignorecase      " ignore case when searching
set smartcase       " ignore case if search pattern is lower case
                    " case-sensitive otherwise
if executable('ag')
	" Note we extract the column as well as the file and line number
	set grepprg=ag\ --nogroup\ --nocolor\ --column
	set grepformat=%f:%l:%c%m
endif

" set ripgrep as the grep command
if executable('rg')
	" Note we extract the column as well as the file and line number
	set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
  set grepformat=%f:%l:%c%m
endif
" }}} Search

" Folding {{{
set foldenable
set foldlevelstart=99  " default folding level when buffer is opened
set foldnestmax=10     " maximum nested fold
set foldmethod=syntax  " fold based on indentation
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
" }}} Folding

let mapleader=","

nnoremap <leader>ff :lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>

set number

if has('autocmd')
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" Significantly better navigation
nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$

" {{{
"
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
"set nobackup
"set nowritebackup

" Give more space for displaying messages.
"set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

nnoremap <leader>h :nohl<CR>

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has('patch-8.1.1564')
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Formatting selected code.
"map <leader>f :PrettierAsync<CR>

map <leader><space> <Plug>(easymotion-prefix)

" Try to NOT do this, because ; is repeat movement.
" map ; :
map <silent> J <C-d>
map <silent> K <C-u>
imap jj <Esc>

imap <C-BS> <C-W>

nnoremap } :bn<CR>
nnoremap { :bp<CR>

nnoremap <c-p> :FZF<CR>
map <leader>n :NvimTreeToggle<CR>

" Functions {{{
" trailing whitespace
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
autocmd BufWritePre * :call TrimWhiteSpace()
" }}}

let g:nord_contrast = v:false                " default false
let g:nord_borders = v:false                 " default false
let g:nord_disable_background = v:true       " default false
let g:nord_italic = v:false                  " default true
let g:nord_uniform_diff_background = v:false " default false
let g:nord_bold = v:false                    " default true

colorscheme nord

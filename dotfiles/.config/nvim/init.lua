-- Set leader key
vim.g.mapleader = ','

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up lazy.nvim
require('lazy').setup('plugins')

-- Basic settings
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.copyindent = true
vim.opt.scrolloff = 4
vim.opt.cursorline = true

-- Search settings
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Folding settings
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 10
vim.opt.foldmethod = 'syntax'

-- Set up grep
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep --smart-case --hidden --follow'
  vim.opt.grepformat = '%f:%l:%c%m'
elseif vim.fn.executable('ag') == 1 then
  vim.opt.grepprg = 'ag --nogroup --nocolor --column'
  vim.opt.grepformat = '%f:%l:%c%m'
end

-- Keymappings
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '0', 'g0')
vim.keymap.set('n', '$', 'g$')
vim.keymap.set('n', '<leader>h', ':nohl<CR>')
vim.keymap.set('n', 'J', '<C-d>')
vim.keymap.set('n', 'K', '<C-u>')
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { silent = true })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { silent = true })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { silent = true })
vim.keymap.set('n', '<c-p>', ':Telescope find_files<CR>', { silent = true })
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>')

vim.keymap.set('n', '<leader>c', ':CopilotChatToggle<CR>')

-- Telescope binds
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { silent = true })

-- Fix odd behavior of tab sometimes not working in command mode
vim.keymap.set('c', '<Tab>', '<C-z>', { silent = true })

-- Autocommands
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line('$') then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Use 'unnamed' for GUI Neovim, 'unnamedplus' for CLI Neovim on Linux/Mac
vim.opt.clipboard = 'unnamed,unnamedplus'

-- Remap copy to system clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y')

-- Remap paste from system clipboard
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p')
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P')

-- Set colorscheme
vim.cmd('colorscheme nord')


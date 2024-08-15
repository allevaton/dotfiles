return {
  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'petertriho/cmp-git',
    },
  },

  -- Copilot
  {
    'github/copilot.vim',
    event = 'InsertEnter',
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      'github/copilot.vim',
    },
    config = function()
      require('CopilotChat').setup({
        debug = true,
        -- Add other configuration options here
      })
    end,
  },

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup{}
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup{}
    end,
  },

  -- Auto tags and pairs
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup{}
    end,
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup{
        disable_filetype = { 'TelescopePrompt', 'vim' },
      }
    end,
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = { 'saadparwaiz1/cmp_luasnip' },
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
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
        indent = { enable = true },
        autotag = { enable = true },
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
      }
    end,
  },

  -- Editing plugins
  'tpope/vim-surround',
  'tpope/vim-repeat',

  -- Prettier
  {
    'prettier/vim-prettier',
    build = 'yarn install',
    ft = {
      'javascript',
      'typescript',
      'css',
      'less',
      'scss',
      'json',
      'graphql',
      'markdown',
      'vue',
      'yaml',
      'html'
    },
  },

  -- Tmux integration
  'christoomey/vim-tmux-navigator',

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        sort = { sorter = 'case_sensitive' },
        view = { width = 40 },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
      }
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = { theme = 'nord' }
      }
    end,
  },

  -- Theme
  {
    'shaunsingh/nord.nvim',
    config = function()
      vim.g.nord_contrast = false
      vim.g.nord_borders = false
      vim.g.nord_disable_background = true
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = false
      vim.g.nord_bold = false
    end,
  },

  -- Minimap
  {
    'wfxr/minimap.vim',
    build = ':!cargo install --locked code-minimap',
  },
}

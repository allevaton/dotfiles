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
          'tsx',
        },
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

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
      },

      -- nvim-treesitter-refactor
      refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = 'grr',
          },
        },
        navigation = {
          enable = true,
          keymaps = {
            -- goto_definition = 'gnd',
            -- list_definitions = 'gnD',
            -- list_definitions_toc = 'gO',
            -- goto_next_usage = '<a-*>',
            -- goto_previous_usage = '<a-#>',
          },
        },
      },

      -- Autotagging (e.g. in HTML, XML)
      autotag = {
        enable = true,
      },

      -- Autoclosing of tags
      autopairs = {
        enable = true,
      },

      indent = {
        enable = false,
      },

      yati = {
        enable = true,
        default_lazy = true,
        default_fallback = 'auto'
      },
    }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      'windwp/nvim-autopairs',
      'yioneko/nvim-yati'
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '▏',
        tab_char = '▏',
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
      },
    },
    config = function(_, opts)
      require('ibl').setup(opts)

      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'IBLWhitespace', { nocombine = true })
      end)
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
        options = {
          theme = 'nord'
        }
      }
    end,
  },

  -- Theme
  {
    'shaunsingh/nord.nvim',
    config = function()
      vim.g.nord_contrast                = false
      vim.g.nord_borders                 = false
      vim.g.nord_disable_background      = true
      vim.g.nord_italic                  = false
      vim.g.nord_uniform_diff_background = false
      vim.g.nord_bold                    = false
    end,
  },

  -- Minimap
  {
    'wfxr/minimap.vim',
    build = ':!cargo install --locked code-minimap',
  },

  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require('null-ls')
      local formatting = null_ls.builtins.formatting

      null_ls.setup({
        sources = {
          formatting.prettier.with({
            filetypes = {
              'javascript',
              'typescript',
              'css',
              'scss',
              'html',
              'json',
              'yaml',
              'markdown',
              'graphql',
              'md',
              'txt',
            },
          }),
        },
      })

      -- Set up format on save
      -- vim.cmd [[augroup FormatAutogroup]]
      -- vim.cmd [[autocmd!]]
      -- vim.cmd [[autocmd BufWritePost * lua vim.lsp.buf.format()]]
      -- vim.cmd [[augroup END]]
    end,
  }
}

return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
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
      'ray-x/lsp_signature.nvim',
      {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        config = function()
          require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
              return { 'treesitter', 'indent' }
            end,
            preview = {
              win_config = {
                border = 'rounded',
                winblend = 0,
                winhighlight = 'Normal:Normal',
                maxheight = 20,
              },
            },
          })

          -- Using ufo provider need remap `zR` and `zM`
          vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
          vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
          vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
          vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
        end,
      },
    },
  },

  -- Mason for LSP, DAP, linter, and formatter management
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'jay-babu/mason-null-ls.nvim',
    },
  },

  -- Null-ls for formatting and linting
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },

  -- Copilot
  {
    'github/copilot.vim',
    event = 'InsertEnter',
  },

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({})
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local pickerOpts = {
        theme = 'dropdown',
        layout_config = {
          width = 0.5,
          height = 0.5,
        },
      }

      require('telescope').setup({
        defaults = {
          cache_picker = {
            num_pickers = 8,
          },
        },
        pickers = {
          find_files = pickerOpts,
          git_files = pickerOpts,
          live_grep = pickerOpts,
          buffers = pickerOpts,
          help_tags = pickerOpts,
          lsp_workspace_symbols = pickerOpts,
          lsp_references = pickerOpts,
        },
      })
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
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup({
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
          'python',
          'tsx',
          'bash',
          'json',
        },
        auto_install = true,
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
        refactor = {
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = false },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = 'gR',
            },
          },
          navigation = {
            enable = true,
            keymaps = {},
          },
        },
        autotag = {
          enable = true,
        },
        autopairs = {
          enable = true,
        },
        indent = {
          enable = false,
        },
        yati = {
          enable = true,
          default_lazy = true,
          default_fallback = 'auto',
        },
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      'windwp/nvim-autopairs',
      'yioneko/nvim-yati',
    },
  },

  -- Rest of your existing plugins...
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '▏',
        tab_char = '▏',
        highlight = { 'NonText' },
        --highlight = { 'CursorColumn' },
      },
      scope = {
        enabled = true,
      },
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
  },

  -- Editing plugins
  'tpope/vim-surround',
  'tpope/vim-repeat',

  -- Tmux integration
  'christoomey/vim-tmux-navigator',

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        sort = { sorter = 'case_sensitive' },
        view = { width = 40 },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
      })
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'nord',
        },
      })
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

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    flavour = 'auto',
    opts = {
      flavour = 'frappe',
    },
  },

  -- Minimap
  -- {
  -- 	"wfxr/minimap.vim",
  -- 	build = ":!cargo install --locked code-minimap",
  -- 	lazy = false,
  -- 	cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
  -- 	init = function()
  -- 		vim.cmd("let g:minimap_width = 10")
  -- 		vim.cmd("let g:minimap_auto_start = 1")
  -- 		vim.cmd("let g:minimap_auto_start_win_enter = 1")
  -- 	end,
  -- },

  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
      hint_enable = false,
      toggle_key = '<C-S-Space>',
    },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy', -- Or `LspAttach`
    priority = 1000,    -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
    preset = 'classic',
    options = {},
  },
  {
    'jiaoshijie/undotree',
    dependencies = 'nvim-lua/plenary.nvim',
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { '<leader>u', '<cmd>lua require(\'undotree\').toggle()<cr>' },
    },
    opts = {
      layout = 'left_bottom',
    },
  },
}

-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
  },

  {
    "NvChad/nvterm",
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,
    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    init = function()
      require("core.utils").lazy_load "nvim-colorizer.lua"
    end,
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.7",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")
      require("indent_blankline").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    config = true,
    event = "VeryLazy",
  },

  -- {
  --   'SmiteshP/nvim-navic',
  --   config = true,
  --   event = "VeryLazy",
  -- },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    init = function()
      require("core.utils").lazy_load "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    event = "VeryLazy",
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- barbar
  -- {
  --   "romgrk/barbar.nvim",
  --   dependencies = {
  --     'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  --     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --   },
  --   init = function() vim.g.barbar_auto_setup = false end,
  --   opts = {
  --     -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
  --     -- animation = true,
  --     -- insert_at_start = true,
  --     -- …etc.
  --   },
  --   config = function(_, opts)
  --     require('barbar').setup(opts)
  --     local map = vim.api.nvim_set_keymap
  --     local key_opts = { noremap = true, silent = true }
  --
  --     -- Move to previous/next
  --     map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', key_opts)
  --     map('n', '<A-.>', '<Cmd>BufferNext<CR>', key_opts)
  --     -- Re-order to previous/next
  --     map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', key_opts)
  --     map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', key_opts)
  --     -- Goto buffer in position...
  --     map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', key_opts)
  --     map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', key_opts)
  --     map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', key_opts)
  --     map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', key_opts)
  --     map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', key_opts)
  --     map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', key_opts)
  --     map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', key_opts)
  --     map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', key_opts)
  --     map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', key_opts)
  --     map('n', '<A-0>', '<Cmd>BufferLast<CR>', key_opts)
  --     -- Pin/unpin buffer
  --     map('n', '<A-p>', '<Cmd>BufferPin<CR>', key_opts)
  --     -- Close buffer
  --     map('n', '<A-c>', '<Cmd>BufferClose<CR>', key_opts)
  --     -- Wipeout buffer
  --     --                 :BufferWipeout
  --     -- Close commands
  --     --                 :BufferCloseAllButCurrent
  --     --                 :BufferCloseAllButPinned
  --     --                 :BufferCloseAllButCurrentOrPinned
  --     --                 :BufferCloseBuffersLeft
  --     --                 :BufferCloseBuffersRight
  --     -- Magic buffer-picking mode
  --     map('n', '<C-p>', '<Cmd>BufferPick<CR>', key_opts)
  --     -- Sort automatically by...
  --     map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', key_opts)
  --     map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', key_opts)
  --     map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', key_opts)
  --     map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', key_opts)
  --
  --     -- Other:
  --     -- :BarbarEnable - enables barbar (enabled by default)
  --     -- :BarbarDisable - very bad command, should never be used
  --
  --   end,
  --   version = '^1.0.0', -- optional: only update when a new 1.x version is released
  --   event = "VeryLazy",
  -- },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function(_, opts)
      require("telescope").load_extension("file_browser")
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<cr>")
    end,
  },

  {
    "jvgrootveld/telescope-zoxide",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function(_, opts)
      require("telescope").load_extension("zoxide")
      vim.keymap.set("n", "<leader>cd", "<cmd>Telescope zoxide list<cr>")
    end,
  },

  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function(_, opts)
      require('neoclip').setup({
        default_register = '+',
        on_select = {
          set_reg = true,
          move_to_front = true,
          close_telescope = true,
        },
        on_paste = {
          set_reg = true,
          move_to_front = true,
          close_telescope = true,
        },
      })
      require("telescope").load_extension("neoclip")
      vim.keymap.set("n", "<leader>fc", "<cmd>Telescope neoclip<cr>")
    end,
  },

  {
    'rmagatti/auto-session',
    config = true,
    lazy = false,
  },

  {
    'Bekaboo/dropbar.nvim',
    config = true,
    event = "VeryLazy",
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    config = true
  },

  {
    "nmac427/guess-indent.nvim",
    keys = {
      { "<leader>gi", "<cmd>GuessIndent<cr>", desc = "Guess indents" },
    },
    config = true,
    lazy = false,
  },

  {
    'tpope/vim-unimpaired',
    config=false,
    lazy=false,
  },
  {
    'tpope/vim-obsession',
    config=false,
    lazy=false,
  },
  {
    'tpope/vim-fugitive',
    config=false,
    lazy=false,
  },
  {
    'tpope/vim-surround',
    config=false,
    lazy=false,
  },

  -- {
  --   "m4xshen/hardtime.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  --   opts = {
  --     disabled_keys = {
  --       ["<Up>"] = {"n"},
  --       ["<>"] = {"n"},
  --     },
  --   },
  --   lazy = false,
  -- },

  -- Snippets
  -- {
  --   'SirVer/ultisnips',
  --   config=false,
  --   lazy=false,
  -- },

  {
    'honza/vim-snippets',
    config=false,
    lazy=false,
  },

  {
    'ojroques/nvim-osc52',
    config = function(_, opts)
      require("osc52").setup()
      vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
      vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
      vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)
    end,
    lazy = false,
  },

  {
    'ibhagwan/smartyank.nvim',
    config = function(_, opts)
      require('smartyank').setup {
        highlight = {
          enabled = true,         -- highlight yanked text
          higroup = "IncSearch",  -- highlight group of yanked text
          timeout = 2000,         -- timeout for clearing the highlight
        },
        clipboard = {
          enabled = true
        },
        tmux = {
          enabled = true,
          -- remove `-w` to disable copy to host client's clipboard
          cmd = { 'tmux', 'set-buffer', '-w' }
        },
        osc52 = {
          enabled = true,
          -- escseq = 'tmux',     -- use tmux escape sequence, only enable if
                                  -- you're using tmux and have issues (see #4)
          ssh_only = false,       -- false to OSC52 yank also in local sessions
          silent = false,         -- true to disable the "n chars copied" echo
          echo_hl = "Directory",  -- highlight group of the OSC52 echo message
        },
        -- By default copy is only triggered by "intentional yanks" where the
        -- user initiated a `y` motion (e.g. `yy`, `yiw`, etc). Set to `false`
        -- if you wish to copy indiscriminately:
        -- validate_yank = false,
        -- 
        -- For advanced customization set to a lua function returning a boolean
        -- for example, the default condition is:
        -- validate_yank = function() return vim.v.operator == "y" end,
      }
    end,
    event = "VeryLazy"
  },

  {
    'tzachar/highlight-undo.nvim',
    config = true,
    event = "VeryLazy",
  },

  {
    'ojroques/nvim-bufdel',
    config = true,
    lazy = false,
  },

  { 'echasnovski/mini.files', version = false, config = true, },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "<C-f>", mode = { "n", "x", "o" },
        function() require("flash").jump() end, desc = "Flash"
      },
      { "<leader>sf", mode = { "n", "o", "x" },
        function() require("flash").treesitter() end, desc = "Flash Treesitter"
      },
      { "<leader>rs", mode = "o",
        function() require("flash").remote() end, desc = "Remote Flash"
      },
      { "<leader>ts", mode = { "o", "x" },
        function() require("flash").treesitter_search() end, desc = "Treesitter Search"
      },
      { "<C-s>", mode = { "c" },
        function() require("flash").toggle() end, desc = "Toggle Flash Search"
      },
    },
  },

  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'smoka7/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      { mode = { 'v', 'n' }, '<Leader>m',
      '<cmd>MCunderCursor<cr>', desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },

  {
    "simrat39/symbols-outline.nvim",
    config = true,
    cmd = { 'SymbolsOutline' },
  },

  {
    'rcarriga/nvim-notify',
    config = function(_, opts)
      vim.notify = require("notify")
    end,
    event = "VeryLazy",
  },

  {
    'debugloop/telescope-undo.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function(_, opts)
      require("telescope").load_extension("undo")
    end,
    keys = { "<leader>" },
    cmd = { "Telescope undo" },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
  },

  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`", "c", "v", "g", "[", "]", "z" },
    -- init = function()
      -- require("core.utils").load_mappings "whichkey"
    -- end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)

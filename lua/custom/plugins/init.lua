--
-- See the kickstart.nvim README for more information
return {
  -- {
  --   vim.cmd 'let g:material_style="deep ocean"',
  -- },
  {
    'marko-cerovac/material.nvim',
    priority = 1000,
    opts = {},
    init = function()
      -- vim.cmd 'let g:material_style="deep ocean"'
      -- vim.cmd 'let g:material_style="lighter"'
      vim.cmd 'let g:material_style="darker"'
      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'

      custom_colors =
        function(colors)
          colors.syntax.comments = '#00FF00'
          -- colors.editor.bg = "#SOME_COLOR",
          -- colors.main.blue = "#SOME_COLOR",
        end, vim.cmd 'colorscheme material'
    end,
  },
  { vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true }) },
  { 'wakatime/vim-wakatime', lazy = false },
  {
    'github/copilot.vim',
    lazy = true,
  },
  {
    -- comment toggle
    -- consider terrortylor/nvim-comment as well
    'tpope/vim-commentary',
  },
  -- Database
  -- { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  { 'tpope/vim-dadbod', lazy = true },
  -- { 'kristijanhusak/vim-dadbod-completion', lazy = true },
  {

    'kristijanhusak/vim-dadbod-ui',
    -- lazy = true,
    -- opts = {
    --   g.db_ui_execute_on_save=true,
    -- },
    -- }
    dependencies = {
      { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
    end,
  },
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('harpoon'):setup()
    end,
    keys = {
      {
        '<leader>A',
        function()
          require('harpoon'):list():append()
        end,
        desc = 'harpoon file',
      },
      {
        '<leader>a',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'harpoon quick menu',
      },
      {
        '<leader>1',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'harpoon to file 1',
      },
      {
        '<leader>2',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'harpoon to file 2',
      },
      {
        '<leader>3',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'harpoon to file 3',
      },
      {
        '<leader>4',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'harpoon to file 4',
      },
      {
        '<leader>5',
        function()
          require('harpoon'):list():select(5)
        end,
        desc = 'harpoon to file 5',
      },
    },
  },
  -- {
  --   'ThePrimeagen/harpoon',
  --   branch = 'harpoon2',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('harpoon'):setup()
  --   end,
  --
  --   keys = {
  --     {
  --       '<leader>A',
  --       function()
  --         require('harpoon'):list():append()
  --       end,
  --       desc = 'harpoon file',
  --     },
  --     {
  --       '<leader>a',
  --       function()
  --         local harpoon = require 'harpoon'
  --         harpoon.ui:toggle_quick_menu(harpoon:list())
  --       end,
  --       desc = 'harpoon quick menu',
  --     },
  --     {
  --       '<leader>1',
  --       function()
  --         require('harpoon'):list():select(1)
  --       end,
  --       desc = 'harpoon to file 1',
  --     },
  --     {
  --       '<leader>2',
  --       function()
  --         require('harpoon'):list():select(2)
  --       end,
  --       desc = 'harpoon to file 2',
  --     },
  --     {
  --       '<leader>3',
  --       function()
  --         require('harpoon'):list():select(3)
  --       end,
  --       desc = 'harpoon to file 3',
  --     },
  --     {
  --       '<leader>4',
  --       function()
  --         require('harpoon'):list():select(4)
  --       end,
  --       desc = 'harpoon to file 4',
  --     },
  --     {
  --       '<leader>5',
  --       function()
  --         require('harpoon'):list():select(5)
  --       end,
  --       desc = 'harpoon to file 5',
  --     },
  --   },
  --   -- require('custom.plugins.harpoon').setup(),
  -- },
  {
    'ThePrimeagen/vim-be-good',
    lazy = true,
  },
  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },
  -- { 'Mofiqul/vscode.nvim' },

  {
    'https://github.com/jamestthompson3/nvim-remote-containers',
    lazy = true,
  },
  {
    'https://codeberg.org/esensar/nvim-dev-container',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    lazy = true,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }

      -- " normal/insert
      -- <Plug>MarkdownPreview
      -- <Plug>MarkdownPreviewStop
      -- <Plug>MarkdownPreviewToggle
      --
      -- -- " example
      -- nmap <C-s> <Plug>MarkdownPreview
      -- nmap <M-s> <Plug>MarkdownPreviewStop
      -- nmap <C-p> <Plug>MarkdownPreviewToggle
      --
    end,
    ft = { 'markdown' },
  },
  -- disable netrw at the very start of your init.lua
  -- vim.g.loaded_netrw = 1
  -- vim.g.loaded_netrwPlugin = 1
  --
  -- -- optionally enable 24-bit colour
  -- vim.opt.termguicolors = true
  --
  -- -- empty setup using defaults
  -- require("nvim-tree").setup()
  --
  -- -- OR setup with some options
  -- require("nvim-tree").setup({
  --   sort = {
  --     sorter = "case_sensitive",
  --   },
  --   view = {
  --     width = 30,
  --   },
  --   renderer = {
  --     group_empty = true,
  --   },
  --   filters = {
  --     dotfiles = true,
  --   },
  -- }),
  --
  --
  --
}
-- test gpg signing in wsl
-- test with ssh and gpg signing and lazygit

-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
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
  {
    -- Database
    'tpope/vim-dadbod',
    'kristijanhusak/vim-dadbod-ui',
    -- opts = {
    --   g.db_ui_execute_on_save=true,
    -- },
    -- }
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    vim.cmd 'let g:db_ui_execute_on_save=0',
  },
  {
    'ThePrimeagen/harpoon',
  },
  {
    'ThePrimeagen/vim-be-good',
  },
  -- {
  --   vim.cmd 'let g:material_style = "deep ocean"',
  -- },
  { 'marko-cerovac/material.nvim', opts = {} },
  {
    'https://github.com/jamestthompson3/nvim-remote-containers',
  },
  {
    'https://codeberg.org/esensar/nvim-dev-container',
    dependencies = 'nvim-treesitter/nvim-treesitter',
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

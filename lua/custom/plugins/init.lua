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
  -- Database
  { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  -- { 'tpope/vim-dadbod', lazy = true },
  { 'kristijanhusak/vim-dadbod-completion', lazy = true },
  {

    'kristijanhusak/vim-dadbod-ui',
    lazy = true,
    opts = {
      db_ui_execute_on_save = false,
    },
    -- }
    dependencies = {
      { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- {
  --   --redundant?
  --   vim.cmd 'let g:db_ui_execute_on_save=0',
  -- },

  {
    'ThePrimeagen/harpoon',
    lazy = true,
  },
  {
    'ThePrimeagen/vim-be-good',
    lazy = true,
  },
  -- { 'Mofiqul/vscode.nvim' },

  -- {
  --   'https://github.com/jamestthompson3/nvim-remote-containers',
  --   lazy = true,
  -- },
  -- {
  --   'https://codeberg.org/esensar/nvim-dev-container',
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  --   lazy = true,
  -- },
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
  -- 'web-tools'.setup({
  --   keymaps = {
  --     rename = nil,  -- by default use same setup of lspconfig
  --     repeat_rename = '.', -- . to repeat
  --   },
  --   hurl = {  -- hurl default
  --     show_headers = false, -- do not show http headers
  --     floating = false,   -- use floating windows (need guihua.lua)
  --     json5 = false,      -- use json5 parser require json5 treesitter
  --     formatters = {  -- format the result by filetype
  --       json = { 'jq' },
  --       html = { 'prettier', '--parser', 'html' },
  --     },
  --   },
  -- })

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

-- function MyFoldtext()
--   local text = vim.treesitter.foldtext()
--
--   -- local n_lines = vim.v.foldend - vim.v.foldstart
--   local n_line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
--   local text_lines = ' lines'
--
--   if n_lines == 1 then
--     text_lines = ' line'
--   end
--
--   table.insert(text, { ' - ' .. n_lines .. text_lines, { 'Folded' } })
--
--   return text
-- end
-- vim.opt.foldtext = 'v:lua.MyFoldtext()'

-- vim.api.nvim_create_autocmd('BufEnter', {
--   callback = function()
--     if vim.opt.foldmethod:get() == 'expr' then
--       vim.schedule(function()
--         vim.opt.foldmethod = 'expr'
--       end)
--     end
--   end,
-- })

-- local function get_custom_foldtext(foldtxt_suffix, foldstart)
--   local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
--   return {
--     { line, 'Normal' },
--     foldtxt_suffix,
--   }
-- end
--
-- _G.get_custom_foldtext = function()
--   local foldstart = vim.v.foldstart
--   local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
--   local foldtxt_suffix = get_custom_foldtxt_suffix(foldstart)
--   return {
--     { line, 'Normal' },
--     foldtxt_suffix,
--   }
-- end
--
local function get_custom_foldtxt_suffix(foldstart)
  local fold_suffix_str = string.format('  %s [%s lines]', '┉', vim.v.foldend - foldstart + 1)
  return { fold_suffix_str, 'Folded' }
end

local function get_custom_foldtext(foldtxt_suffix, foldstart)
  local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
  return {
    { line, 'Normal' },
    foldtxt_suffix,
  }
end

-- local function get_custom_foldtxt_suffix(foldstart)
--   local fold_suffix_str = string.format('  %s [%s lines]', '┉', vim.v.foldend - foldstart + 1)
--   return { fold_suffix_str, 'Folded' }
-- end

-- _G.get_custom_foldtext = function()
--   local foldstart = vim.v.foldstart
--   local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
--   local foldtxt_suffix = get_custom_foldtxt_suffix(foldstart)
--   return {
--     { line, 'Normal' },
--     foldtxt_suffix,
--   }
-- end

--
--
_G.get_foldtext = function()
  local foldstart = vim.v.foldstart
  local ts_foldtxt = vim.treesitter.foldtext()
  local foldtxt_suffix = get_custom_foldtxt_suffix(foldstart)

  if type(ts_foldtxt) == 'string' then
    return get_custom_foldtext(foldtxt_suffix, foldstart)
  end

  table.insert(ts_foldtxt, foldtxt_suffix)
  return ts_foldtxt
end

vim.opt.foldmethod = 'expr'
vim.opt.foldlevel = 50
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.opt.foldtext = 'get_custom_foldtext()'
-- vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'

-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldtext = 'lua.custom.plugins.test_folding_treesitter.'
-- vim.opt.foldtext = 'v:'
-- vim.opt.foldtext = 'nvim_treesitter.foldtext()'
-- vim.cmd [[ set nofoldenable]]
-- {
--   function()
--     vim.opt.foldmethod = 'expr'
--     --     --     vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
--     --     --     vim.opt.foldtext = 'nvim_treesitter.foldtext()'
--     --     --     vim.cmd [[ set nofoldenable]]
--     --     --
--     --     --     -- vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--     --     --     -- vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'
--   end,

return {
  -- {
  --   config = function()
  --     require('lua.custom.plugins.test_folding_treesitter').setup()
  --   end,
  -- },

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
  -- -- Database
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
    config = function()
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

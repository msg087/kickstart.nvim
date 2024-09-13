-- return {
--   -- Database
--   'tpope/vim-dadbod',
--   'kristijanhusak/vim-dadbod-ui',
--   'kristijanhusak/vim-dadbod-completion',
--
--   dependencies = {
--     { 'tpope/vim-dadbod', lazy = true },
--     { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
--   },
--   init = function()
--     -- Your DBUI configuration
--     vim.g.db_ui_use_nerd_fonts = 1
--     vim.g.db_ui_execute_on_save = 0
--   end,
-- }
--

return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'kristijanhusak/vim-dadbod-completion',
    },
    -- override the options table that is used in the `require("cmp").setup()` call
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require 'cmp'
      -- modify the sources part of the options table
      opts.sources = cmp.config.sources {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 250 },
        { name = 'vim-dadbod-completion', priority = 700 }, -- add new source
      }
      -- return the new table to be used
      return opts
    end,
  },
}

--
-- return {
--   {
--     "kristijanhusak/vim-dadbod-ui",
--     dependencies = {
--       { "tpope/vim-dotenv", lazy = true },
--       { "tpope/vim-dadbod", lazy = true },
--       { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
--     },
--     cmd = {
--       "DBUI",
--       "DBUIToggle",
--       "DBUIAddConnection",
--       "DBUIFindBuffer",
--     },
--     init = function()
--       vim.g.db_ui_use_nerd_fonts = 1
--       vim.g.db_ui_winwidth = 30
--       vim.g.db_ui_show_help = 0
--       vim.g.db_ui_use_nvim_notify = 1
--       vim.g.db_ui_win_position = "left"
--
--       require("which-key").register {
--         ["<leader>D"] = {
--           name = "󰆼 Db Tools",
--           u = { "<cmd>DBUIToggle<cr>", " DB UI Toggle" },
--           f = { "<cmd>DBUIFindBuffer<cr>", " DB UI Find buffer" },
--           r = { "<cmd>DBUIRenameBuffer<cr>", " DB UI Rename buffer" },
--           l = { "<cmd>DBUILastQueryInfo<cr>", " DB UI Last query infos" },
--         },
--       }
--     end,
--   },
-- }
--

-- local mappings = {
--   S = {
--     name = 'Database',
--     u = { '<Cmd>DBUIToggle<Cr>', 'Toggle UI' },
--     f = { '<Cmd>DBUIFindBuffer<Cr>', 'Find buffer' },
--     r = { '<Cmd>DBUIRenameBuffer<Cr>', 'Rename buffer' },
--     q = { '<Cmd>DBUILastQueryInfo<Cr>', 'Last query info' },
--   },
--

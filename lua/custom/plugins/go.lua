return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig', -- ensures lspconfig is loaded before config runs
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod' },
    config = function()
      require('go').setup()
      lsp_on_attach = true

      require('which-key').add {
        { '<leader>gl', '<cmd>GoLint<CR>', desc = 'Go Lint', mode = { 'n' } },
        { '<leader>gc', '<cmd>GoCmt<CR>', desc = 'Go Add Comment', mode = { 'n' } },
        { '<leader>gd', '<cmd>GoDoc<CR>', desc = 'Go Doc', mode = { 'n' } },
        { '<leader>gm', '<cmd>GoModTidy<CR>', desc = 'Go Mod Tidy', mode = { 'n' } },
        { '<leader>gi', '<cmd>GoToggleInlay<CR>', desc = 'Go Toggle Inlay Hints', mode = { 'n' } },

        { '<leader>gta', '<cmd>GoTest -c<CR>', desc = 'Go Test all (current file path)', mode = { 'n' } },
        { '<leader>gtc', '<cmd>GoCoverage<CR>', desc = 'Go Test -coverprofile', mode = { 'n' } },
        { '<leader>gtn', '<cmd>GoTest -n<CR>', desc = 'Go Test nearest', mode = { 'n' } },
        { '<leader>gtf', '<cmd>GoTestFile -F<CR>', desc = 'Go Test file', mode = { 'n' } },
        { '<leader>gtp', '<cmd>GoTestPkg<CR>', desc = 'Go Test package (current)', mode = { 'n' } },
        { '<leader>gtn', '<cmd>GoTestFunc<CR>', desc = 'Go Test function (current)', mode = { 'n' } },

        -- { '<leader>gd', '<cmd>GoDef<CR>', desc = 'Go Def', mode = { 'n' } },
        -- { '<leader>gt', '<cmd>GoTest<CR>', desc = 'Go Test', mode = { 'n' } },
        -- { '<leader>gr', '<cmd>GoRun<CR>', desc = 'Go Run', mode = { 'n' } },
        -- { '<leader>gb', '<cmd>GoBuild<CR>', desc = 'Go Build', mode = { 'n' } },
        -- { '<leader>gc', '<cmd>GoCoverage<CR>', desc = 'Go Coverage', mode = { 'n' } },
        -- { '<leader>gg', '<cmd>GoGenerate<CR>', desc = 'Go Generate', mode = { 'n' } },
        -- { '<leader>gi', '<cmd>GoInstall<CR>', desc = 'Go Install', mode = { 'n' } },
      }
    end,
    event = { 'CmdlineEnter' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}

-- return {
--       -- require('lspconfig').pyright.setup {
--   {
--   "ray-x/go.nvim",
--   dependencies = {  -- optional packages
--     "ray-x/guihua.lua",
--     "neovim/nvim-lspconfig",
--     "nvim-treesitter/nvim-treesitter",
--   },
--   opts = {
--     -- lsp_keymaps = false,
--     -- other options
--   },
--   config = function(lp, opts)
--     require("go").setup(opts)
--     local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       pattern = "*.go",
--       callback = function()
--       require('go.format').goimports()
--       end,
--       group = format_sync_grp,
--     })
--   end,
--   event = {"CmdlineEnter"},
--   ft = {"go", 'gomod'},
--   build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
-- },

--   {
-- require('lspconfig').gopls.setup({
--   settings = {
--     gopls = {
--       staticcheck = true,
--     },
--   },
-- })
--   },
-- }
-- return {
--   {
--     "ray-x/go.nvim",
--     dependencies = {
--       "ray-x/guihua.lua",
--       "neovim/nvim-lspconfig",
--       "nvim-treesitter/nvim-treesitter",
--     },
--     opts = {},
--     config = function(_, opts)
--       require("go").setup(opts)
--
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         pattern = "*.go",
--         callback = function()
--           require("go.format").goimports()
--         end,
--         group = vim.api.nvim_create_augroup("GoFormat", {}),
--       })
--
--       -- DO NOT manually call lspconfig.gopls.setup() here
--       -- Let mason-lspconfig from lsp.lua handle it
--     end,
--     ft = { "go", "gomod" }, -- <-- keep this
--   }
-- }
--

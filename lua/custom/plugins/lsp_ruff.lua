return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'ruff', 'pyright' },
      }

      -- Set up Ruff
      require('lspconfig').ruff.setup {
        cmd = { 'ruff', 'server', '--preview' },
        filetypes = { 'python' },
        init_options = {
          configuration = vim.fn.expand('~/.config/ruff/pyproject.toml'),
          configurationPreference = 'editorFirst',
          logLevel = 'debug',
        },
        on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true

          -- Optional: format on <leader>f
          vim.api.nvim_buf_set_keymap(
            bufnr,
            'n',
            '<leader>f',
            '<cmd>lua vim.lsp.buf.format({ async = true })<CR>',
            { noremap = true, silent = true }
          )
        end,
      }

      -- Set up Pyright (disable formatting to let Ruff handle it)
      require('lspconfig').pyright.setup {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              ignore = { '*' },
              typeCheckingMode = 'basic',
            },
          },
        },
      }

      -- Global diagnostics config
      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
      }

      -- Show float diagnostics on hover
      vim.o.updatetime = 250
      vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]
    end,
  },
}



-- return {
--   {
--     'neovim/nvim-lspconfig',
--     dependencies = {
--       'williamboman/mason.nvim',
--       'williamboman/mason-lspconfig.nvim',
--     },
--     config = function()
--       require('mason').setup()
--       require('mason-lspconfig').setup {
--         ensure_installed = { 'ruff', 'pyright' },
--       }
--
-- require('lspconfig').ruff.setup {
--   cmd = { 'ruff', 'server', '--preview' },
--   filetypes = { 'python' },
--   init_options = {
--     configuration = vim.fn.expand('~/.config/ruff/pyproject.toml'),
--     configurationPreference = 'editorFirst',
--     logLevel = 'debug',
--   },
--   on_attach = function(client, bufnr)
--     -- Enable formatting support explicitly
--     client.server_capabilities.documentFormattingProvider = true
--
--     -- Optional: Map <leader>f for formatting
--     vim.api.nvim_buf_set_keymap(
--       bufnr,
--       'n',
--       '<leader>f',
--       '<cmd>lua vim.lsp.buf.format({ async = true })<CR>',
--       { noremap = true, silent = true }
--     )
--   end,  -- ← You were missing this
-- }
--
--
-- --       require('lspconfig').ruff.setup {
-- --         cmd = { 'ruff', 'server', '--preview' },
-- --         filetypes = { 'python' },
-- --         init_options = {
-- --           -- settings = {
-- --             configuration = vim.fn.expand '~/.config/ruff/pyproject.toml',
-- --             configurationPreference = 'editorFirst',
-- --             logLevel = 'debug',
-- --             -- Add any Ruff-specific settings here
-- --           -- },
-- --         },
-- --
-- --   on_attach = function(client, bufnr)
-- --     -- Manually enable formatting capabilities
-- --     client.server_capabilities.documentFormattingProvider = true
-- --
-- --  -- Optional: define <leader>f for this buffer if needed
-- --     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { noremap = true, silent = true })
-- --
-- -- end,
-- --
-- --       }
--
--       -- Configure Pyright
--       require('lspconfig').pyright.setup {
--         settings = {
--           pyright = {
--             disableOrganizeImports = true, -- Let Ruff handle import organization
--           },
--           python = {
--             analysis = {
--               ignore = { '*' }, -- Let Ruff handle linting
--               typeCheckingMode = 'basic', -- Enable type checking
--             },
--           },
--         },
--       }
--
--       vim.diagnostic.config {
--         virtual_text = true,
--         signs = true,
--         update_in_insert = true,
--       }
--
--   -- Optional: show float diagnostics on hover
--       vim.o.updatetime = 250
--       vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]
--
--     end,
--   },
-- }

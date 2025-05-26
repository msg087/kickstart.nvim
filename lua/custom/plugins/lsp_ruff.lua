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

      require('lspconfig').ruff.setup {
        cmd = { 'ruff', 'server', '--preview' },
        filetypes = { 'python' },
        init_options = {
          settings = {
            logLevel = 'debug',
            configuration = vim.fn.expand '~/.config/ruff/pyproject.toml',
            configurationPreference = 'clientFirst',
            -- Add any Ruff-specific settings here
          },
        },
      }

      -- Configure Pyright
      require('lspconfig').pyright.setup {
        settings = {
          pyright = {
            disableOrganizeImports = true, -- Let Ruff handle import organization
          },
          python = {
            analysis = {
              ignore = { '*' }, -- Let Ruff handle linting
              typeCheckingMode = 'basic', -- Enable type checking
            },
          },
        },
      }

      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
      }
    end,
  },
}

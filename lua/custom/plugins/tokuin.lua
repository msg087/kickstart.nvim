return {
  {
    'folke/which-key.nvim',
    opts = function(_, opts)
      local tokuin = require 'custom.custom_modules.tokuin'

      -- ensure spec exists
      opts.spec = opts.spec or {}

      -- add mappings
      vim.list_extend(opts.spec, {
        { '<leader>l', group = '[L]LM' },
        {
          '<leader>lk',
          function()
            tokuin.file()
          end,
          desc = 'Token count (file)',
        },
        {
          '<leader>lk',
          function()
            tokuin.selection()
          end,
          desc = 'Token count (selection)',
          mode = 'v',
        },
      })
    end,
  },
}

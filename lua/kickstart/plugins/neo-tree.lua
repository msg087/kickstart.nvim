-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },

  -- init = function()
  --   if vim.fn.argc(-1) == 1 then
  --     local plugin = require('lazy.core.config').spec.plugins['LazyVim']
  --     local Opts = require('lazy.core.plugin').values(plugin, 'opts', false)
  --     local stat = vim.loop.fs_stat(vim.fn.argv(0))
  --     if stat and stat.type == 'directory' then
  --       require 'neo-tree'
  --       vim.defer_fn(function()
  --         return Opts.colorscheme and vim.cmd.colorscheme(Opts.colorscheme) or vim.cmd.colorscheme 'tokyonight'
  --       end, 100)
  --     end
  --   end
  -- end,
}

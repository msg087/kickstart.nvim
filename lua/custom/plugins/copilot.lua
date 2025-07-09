return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    enabled = false,
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          -- accept = false,
          -- accept = '<M-.>',
          -- accept = false, -- handled by nvim-cmp / blink.cmp
          next = '<M-]>',
          prev = '<M-[>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        python = true,
        bash = true,
        lua = true,
        tsx = true,
        ts = true,
        help = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
      --had to do this to get the keymap to work
      vim.keymap.set('i', '<M-.>', function()
        require('copilot.suggestion').accept()
        -- print('Alt + . pressed!')
      end, { noremap = true, silent = true })
    end,
  },



  -- {
  --   vim.api.nvim_create_autocmd('User', {
  --     pattern = 'BlinkCmpMenuOpen',
  --     callback = function()
  --       vim.b.copilot_suggestion_hidden = true
  --     end,
  --   }),
  -- },
  -- {
  --
  --   vim.api.nvim_create_autocmd('User', {
  --     pattern = 'BlinkCmpMenuClose',
  --     callback = function()
  --       vim.b.copilot_suggestion_hidden = false
  --     end,
  --   }),
  -- },
  -- {
  --   'github/copilot.vim',
  --  p-- lazy = true,
  -- }p
}

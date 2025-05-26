return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = '<CR>',
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
  --   -- lazy = true,
  -- },
}

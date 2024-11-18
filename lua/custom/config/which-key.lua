local M = {}

function M.setup()
  local whichkey = require 'which-key'

  local conf = {
    window = {
      border = 'double', -- none, single, double, shadow
      position = 'bottom', -- bottom, top
    },
  }

  -- vim.keymap.set('n', '<leader>sca', function()
  --   builtin.find_files { search_dirs = '/mnt/c/code/aws/' }
  -- end, { desc = '[S]earch [C]ode [A]WS files' })
  --
  -- vim.keymap.set('n', '<leader>sco', function()
  --   builtin.find_files { search_dirs = '/mnt/c/code/ob/' }
  -- end, { desc = '[S]earch [C]ode [O]b files' })

  -- {
  --   { "<leader>", "<leader>Sq", desc = "<Cmd>DBUILastQueryInfo<Cr>", nowait = false, remap = false },
  --   { "<leader>", "<leader>mm", desc = "<Cmd>MarkdownPreview<Cr>", nowait = false, remap = false },
  --   { "<leader>", group = "Database", nowait = false, remap = false },
  --   { "<leader>", "<leader>Su", desc = "<Cmd>DBUIToggle<Cr>", nowait = false, remap = false },
  --   { "<leader>", "<leader>Sr", desc = "<Cmd>DBUIRenameBuffer<Cr>", nowait = false, remap = false },
  --   { "<leader>", "<leader>Sf", desc = "<Cmd>DBUIFindBuffer<Cr>", nowait = false, remap = false },
  --   { "<leader>", group = "Markdown", nowait = false, remap = false },
  --   { "<leader>", "<leader>ms", desc = "<Cmd>MarkdownPreviewStop<Cr>", nowait = false, remap = false },
  -- }
  local opts = {
    mode = 'n', -- Normal mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  local mappings = {
    { '<leader>S', group = 'Database', nowait = false, remap = false },
    { '<leader>Sf', '<Cmd>DBUIFindBuffer<Cr>', desc = 'Find buffer', nowait = false, remap = false },
    { '<leader>Sq', '<Cmd>DBUILastQueryInfo<Cr>', desc = 'Last query info', nowait = false, remap = false },
    { '<leader>Sr', '<Cmd>DBUIRenameBuffer<Cr>', desc = 'Rename buffer', nowait = false, remap = false },
    { '<leader>Su', '<Cmd>DBUIToggle<Cr>', desc = 'Toggle UI', nowait = false, remap = false },
    { '<leader>m', group = 'Markdown', nowait = false, remap = false },
    { '<leader>mm', '<Cmd>MarkdownPreview<Cr>', desc = 'Show MD Preview', nowait = false, remap = false },
    { '<leader>ms', '<Cmd>MarkdownPreviewStop<Cr>', desc = 'Stop MD Preview', nowait = false, remap = false },
    -- S = {
    --   name = 'Database',
    --   u = { '<Cmd>DBUIToggle<Cr>', 'Toggle UI' },
    --   f = { '<Cmd>DBUIFindBuffer<Cr>', 'Find buffer' },
    --   r = { '<Cmd>DBUIRenameBuffer<Cr>', 'Rename buffer' },
    --   q = { '<Cmd>DBUILastQueryInfo<Cr>', 'Last query info' },
    -- },
    --
    -- m = {
    --   name = 'Markdown',
    --   m = { '<Cmd>MarkdownPreview<Cr>', 'Show MD Preview' },
    --   s = { '<Cmd>MarkdownPreviewStop<Cr>', 'Stop MD Preview' },
    -- },
    --
    -- c = {
    --   name = 'code',
    --   a = { '<Cmd> Telescope find_files search_dirs = {"/mnt/c/code/aws/"}<Cr>', 'Search AWS code' },
    --   o = { '<Cmd> Telescope find_files search_dirs = {"/mnt/c/code/ob/"}<Cr>', 'Search OB code' },
    -- },
  }

  whichkey.setup(conf)
  -- whichkey.register(mappings, opts)
end

return M

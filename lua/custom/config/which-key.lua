local M = {}

function M.setup()
  local whichkey = require 'which-key'

  local conf = {
    window = {
      border = 'double', -- none, single, double, shadow
      position = 'bottom', -- bottom, top
    },
  }

  local opts = {
    mode = 'n', -- Normal mode
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  local mappings = {
    --database
    { '<leader>S', group = 'Database', nowait = false, remap = false },
    { '<leader>Sf', '<Cmd>DBUIFindBuffer<Cr>', desc = 'Find buffer', nowait = false, remap = false },
    { '<leader>Sq', '<Cmd>DBUILastQueryInfo<Cr>', desc = 'Last query info', nowait = false, remap = false },
    { '<leader>Sr', '<Cmd>DBUIRenameBuffer<Cr>', desc = 'Rename buffer', nowait = false, remap = false },
    { '<leader>Su', '<Cmd>DBUIToggle<Cr>', desc = 'Toggle UI', nowait = false, remap = false },

    --markdown
    { '<leader>m', group = 'Markdown', nowait = false, remap = false },
    { '<leader>mm', '<Cmd>MarkdownPreview<Cr>', desc = 'Show MD Preview', nowait = false, remap = false },
    { '<leader>ms', '<Cmd>MarkdownPreviewStop<Cr>', desc = 'Stop MD Preview', nowait = false, remap = false },

    --
    -- c = {
    --   name = 'code',
    --   a = { '<Cmd> Telescope find_files search_dirs = {"/mnt/c/code/aws/"}<Cr>', 'Search AWS code' },
    --   o = { '<Cmd> Telescope find_files search_dirs = {"/mnt/c/code/ob/"}<Cr>', 'Search OB code' },
    -- },
  }

  whichkey.setup(conf)
end

return M

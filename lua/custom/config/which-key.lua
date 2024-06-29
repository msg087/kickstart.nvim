local M = {}

function M.setup()
  local whichkey = require 'which-key'

  local conf = {
    window = {
      border = 'single', -- none, single, double, shadow
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
    S = {
      name = 'Database',
      u = { '<Cmd>DBUIToggle<Cr>', 'Toggle UI' },
      f = { '<Cmd>DBUIFindBuffer<Cr>', 'Find buffer' },
      r = { '<Cmd>DBUIRenameBuffer<Cr>', 'Rename buffer' },
      q = { '<Cmd>DBUILastQueryInfo<Cr>', 'Last query info' },
    },

    m = {
      name = 'Markdown',
      m = { '<Cmd>MarkdownPreview<Cr>', 'Show MD Preview' },
      s = { '<Cmd>MarkdownPreviewStop<Cr>', 'Stop MD Preview' },
    },
  }

  whichkey.setup(conf)
  whichkey.register(mappings, opts)
end

return M

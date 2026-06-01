local fmt = require 'custom.custom_modules.formatting'

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },

        -- Database
        { '<leader>S', group = 'Database', nowait = false, remap = false },
        { '<leader>Sf', '<Cmd>DBUIFindBuffer<Cr>', desc = 'Find buffer', nowait = false, remap = false },
        { '<leader>Sq', '<Cmd>DBUILastQueryInfo<Cr>', desc = 'Last query info', nowait = false, remap = false },
        { '<leader>Sr', '<Cmd>DBUIRenameBuffer<Cr>', desc = 'Rename buffer', nowait = false, remap = false },
        { '<leader>Su', '<Cmd>DBUIToggle<Cr>', desc = 'Toggle UI', nowait = false, remap = false },

        --markdown
        { '<leader>m', group = 'Markdown', nowait = false, remap = false },
        { '<leader>mm', '<Cmd>MarkdownPreview<Cr>', desc = 'Show MD Preview', nowait = false, remap = false },
        { '<leader>ms', '<Cmd>MarkdownPreviewStop<Cr>', desc = 'Stop MD Preview', nowait = false, remap = false },

        { '<leader>F', group = '[F]ormat custom', nowait = false, remap = false },
        { '<leader>Fjj', fmt.format_json, desc = 'Format JSON', nowait = false, remap = false },
        { '<leader>Fje', fmt.format_escaped_json, desc = 'Format [e]scaped JSON', nowait = false, remap = false },
        { '<leader>Fjn', fmt.expand_embedded_json, desc = 'Format [n]ested escaped JSON', nowait = false, remap = false },
        { '<leader>Fxx', fmt.format_xml, desc = 'Format [x]ml', nowait = false, remap = false },
        { '<leader>Fxr', fmt.recover_xml, desc = 'Format [r]ecover xml', nowait = false, remap = false },
      },
    },
  },
}

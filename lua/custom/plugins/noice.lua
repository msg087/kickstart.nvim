return {
  -- lazy.nvim
  {
    'folke/noice.nvim',
    enabled = false,
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },

    config = function()
      require('noice').setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
          },
        },

        cmdline = {
          enabled = true,
          view = 'cmdline',
          -- view = 'cmdline_popup',
        },

        sections = {
          lualine_x = {
            {
              require('noice').api.statusline.mode.get,
              cond = require('noice').api.statusline.mode.has,
              color = { fg = '#ff9e64' },
            },
          },
        },

        routes = {
          {
            view = 'notify',
            filter = { event = 'msg_showmode' },
          },
          -- {
          --   filter = {
          --     event = 'msg_show',
          --     kind = 'search_count',
          --   },
          --   opts = { skip = false },
          -- },
        },

        views = {
          cmdline_popup = {
            position = {
              row = '50%',
              col = '50%',
            },
            size = {
              width = 60,
              height = 'auto',
            },
          },

          popupmenu = {
            relative = 'editor',
            position = {
              row = 8,
              col = '50%',
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = 'rounded',
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
            },
          },
        },

        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }

      vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
        if not require('noice.lsp').scroll(4) then
          return '<c-f>'
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
        if not require('noice.lsp').scroll(-4) then
          return '<c-b>'
        end
      end, { silent = true, expr = true })
    end,
  },
}

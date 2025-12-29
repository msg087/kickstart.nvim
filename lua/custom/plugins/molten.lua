local has_luarocks = vim.fn.executable 'luarocks' == 1

-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ';' .. vim.fn.expand '$HOME' .. '/.luarocks/share/lua/5.1/?/init.lua'
package.path = package.path .. ';' .. vim.fn.expand '$HOME' .. '/.luarocks/share/lua/5.1/?.lua'

-- automatically import output chunks from a jupyter notebook
-- tries to find a kernel that matches the kernel in the jupyter notebook
-- falls back to a kernel that matches the name of the active venv (if any)
local imb = function(e) -- init molten buffer
  vim.schedule(function()
    local kernels = vim.fn.MoltenAvailableKernels()
    local try_kernel_name = function()
      local metadata = vim.json.decode(io.open(e.file, 'r'):read 'a')['metadata']
      return metadata.kernelspec.name
    end
    local ok, kernel_name = pcall(try_kernel_name)
    if not ok or not vim.tbl_contains(kernels, kernel_name) then
      kernel_name = nil
      local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
      if venv ~= nil then
        kernel_name = string.match(venv, '/.+/(.+)')
      end
    end
    if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
      vim.cmd(('MoltenInit %s'):format(kernel_name))
    end
    vim.cmd 'MoltenImportOutput'
  end)
end

-- automatically import output chunks from a jupyter notebook
vim.api.nvim_create_autocmd('BufAdd', {
  pattern = { '*.ipynb' },
  callback = imb,
})

-- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.ipynb' },
  callback = function(e)
    if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
      imb(e)
    end
  end,
})

-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. '.ipynb'
  local file = io.open(path, 'w')
  if file then
    file:write(default_notebook)
    file:close()
    vim.cmd('edit ' .. path)
  else
    print 'Error: Could not open new notebook file for writing.'
  end
end

vim.api.nvim_create_user_command('NewNotebook', function(opts)
  new_notebook(opts.args)
end, {
  nargs = 1,
  complete = 'file',
})

-- if has_luarocks then
--   local ok = pcall(require, 'magick')
--   if not ok then
--     print 'Installing magick rock…'
--     os.execute 'luarocks --local --lua-version=5.1 install magick'
--   end
-- end

return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { 'magick' },
    },
  },
  {
    '3rd/image.nvim',
    -- cond = has_luarocks,
    -- rocks = { 'magick == 1.6.0' },
    -- dependencies = { 'luarocks.nvim' },
    ft = { 'markdown', 'vimwiki', 'png', 'jpeg', 'jpg', 'gif', 'webp', 'avif' },
    -- build = false,
    config = function()
      require('image').setup {
        backend = 'kitty', -- or "wezterm" / "sixel" "kitty"
        kitty_method = 'normal', -- default used internally

        processor = 'magick_rock', --or magick_cli or magick_rock
        -- processor = 'magick_cli', --or magick_cli or magick_rock

        -- 🔑 DO NOT enable markdown integrations for Molten ???
        -- integrations = {},
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            only_render_image_at_cursor_mode = 'popup', -- or "inline"
            floating_windows = false, -- if true, images will be rendered in floating markdown windows
            filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
          },
          -- neorg = {
          --   enabled = true,
          --   filetypes = { "norg" },
          -- },
          -- typst = {
          --   enabled = true,
          --   filetypes = { "typst" },
          -- },
          -- html = {
          --   enabled = false,
          -- },
          -- css = {
          --   enabled = false,
          -- },
        },

        -- 🔥 REQUIRED to prevent crashes
        max_width = 300,
        max_height = 50,
        molten_wrap_output = true,
        -- molten_virtual_text_output = true,
        -- molten_virt_lines_off_by_1 = true,

        -- 🔥 REQUIRED for Molten floating output windows
        max_width_window_percentage = math.huge,
        max_height_window_percentage = math.huge,

        window_overlap_clear_enabled = false,
        -- window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },

        -- max_width = nil,
        -- max_height = nil,
        -- max_width_window_percentage = nil,
        -- max_height_window_percentage = 50,
        scale_factor = 1.0,
        -- window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'snacks_notif', 'scrollview', 'scrollview_sign' },
        editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' }, -- render image files as images when opened
      }
    end,
  },

  {
    'benlubas/molten-nvim',
    version = '*',
    build = ':UpdateRemotePlugins',
    lazy = false, -- load on startup so commands are always available

    -- Global options (must be set before the plugin loads)
    init = function()
      -- Use plain text output by default (no image.nvim / wezterm required)
      if has_luarocks then
        vim.g.molten_image_provider = 'image.nvim'
      else
        vim.g.molten_image_provider = 'none' -- or 'kitty' if supported
      end
      -- vim.g.molten_image_provider = 'image.nvim'

      -- Show a floating window automatically when you enter a cell
      vim.g.molten_auto_open_output = true

      -- Also keep output as virtual text under the cell (nice for quick glance)
      vim.g.molten_virt_text_output = true
      vim.g.molten_output_virt_lines = true
      vim.g.molten_virt_text_max_lines = 12

      -- Keep floating windows a reasonable size
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_output_win_style = 'minimal'
      vim.g.molten_output_win_border = { '', '━', '', '' }

      -- Snappier UI updates
      vim.g.molten_tick_rate = 200
    end,

    config = function()
      local map = vim.keymap.set

      ---------------------------------------------------------------------------
      -- Helpers
      ---------------------------------------------------------------------------

      -- Run the currently visually-selected *lines* using MoltenEvaluateRange
      -- Works for v / V / Ctrl-v selections; normalizes direction (up/down).
      local function molten_run_visual_lines()
        local mode = vim.fn.mode()
        if not mode:match '[vV\22]' then
          return
        end

        -- visual start ("v") and cursor (".")
        local vstart = vim.fn.getpos('v')[2]
        local vend = vim.fn.getpos('.')[2]

        if vstart > vend then
          vstart, vend = vend, vstart
        end

        -- No kernel_id passed: if multiple kernels are attached,
        -- Molten will prompt; otherwise it uses the only one.
        -- If you always want a specific kernel, do:
        -- vim.fn.MoltenEvaluateRange("molten", vstart, vend)
        vim.fn.MoltenEvaluateRange(vstart, vend)
      end

      -- Nice “smart run”: if in a cell, re-eval; otherwise run current line
      local function molten_run_cell_or_line()
        local ok = pcall(vim.cmd, 'MoltenReevaluateCell')
        if not ok then
          vim.cmd 'MoltenEvaluateLine'
        end
      end

      ---------------------------------------------------------------------------
      -- Keymaps
      -- Using <leader>m* as a Molten “namespace”
      ---------------------------------------------------------------------------

      -- Initialize a kernel for this buffer (will prompt for kernel name)
      map('n', '<leader>mi', ':MoltenInit<CR>', {
        desc = 'Molten: init kernel',
        silent = true,
      })

      -- Run current line (plain)
      map('n', '<leader>ml', ':MoltenEvaluateLine<CR>', {
        desc = 'Molten: run line',
        silent = true,
      })

      -- Smart run: re-run cell if you're in one, else run line
      map('n', '<leader>mr', molten_run_cell_or_line, {
        desc = 'Molten: re-run cell or run line',
        silent = true,
      })

      -- Run a *range of lines* using visual selection (what you asked for)
      -- Usage: V (select lines), then <leader>mR
      map('v', '<leader>mR', molten_run_visual_lines, {
        desc = 'Molten: run visual line range',
        silent = true,
        noremap = true,
      })

      -- Operator-pending: run “whatever motion I do next” as a range
      -- e.g. <leader>me}  → run to end of paragraph
      --      <leader>meap → run a paragraph
      --      <leader>meG  → run to EOF
      map('n', '<leader>me', ':MoltenEvaluateOperator<CR>', {
        desc = 'Molten: run motion/selection (operator)',
        silent = true,
      })

      -- Re-evaluate the current cell (including edits inside it)
      map('n', '<leader>mm', ':MoltenReevaluateCell<CR>', {
        desc = 'Molten: re-run current cell',
        silent = true,
      })

      -- Delete current cell / all cells
      map('n', '<leader>md', ':MoltenDelete<CR>', {
        desc = 'Molten: delete current cell',
        silent = true,
      })
      map('n', '<leader>mD', ':MoltenDelete!<CR>', {
        desc = 'Molten: delete ALL cells in buffer',
        silent = true,
      })

      -- Navigation between cells
      map('n', '<leader>mn', ':MoltenNext<CR>', {
        desc = 'Molten: next cell',
        silent = true,
      })
      map('n', '<leader>mp', ':MoltenPrev<CR>', {
        desc = 'Molten: previous cell',
        silent = true,
      })

      -- Output handling
      map('n', '<leader>mo', ':noautocmd MoltenEnterOutput<CR>', {
        desc = 'Molten: show/enter output window',
        silent = true,
      })
      map('n', '<leader>mh', ':MoltenHideOutput<CR>', {
        desc = 'Molten: hide output window',
        silent = true,
      })
      map('n', '<leader>ms', ':MoltenShowOutput<CR>', {
        desc = 'Molten: show output window (no focus)',
        silent = true,
      })

      -- Info / debug
      map('n', '<leader>mI', ':MoltenInfo<CR>', {
        desc = 'Molten: info',
        silent = true,
      })
    end,
  },
  {
    'GCBallesteros/jupytext.nvim',
    opts = {
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
    },
  },
  --
}

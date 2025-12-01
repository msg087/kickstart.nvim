-- lua/plugins/molten.lua
return {
  'benlubas/molten-nvim',
  version = '*',
  build = ':UpdateRemotePlugins',
  lazy = false, -- load on startup so commands are always available

  -- Global options (must be set before the plugin loads)
  init = function()
    -- Use plain text output by default (no image.nvim / wezterm required)
    vim.g.molten_image_provider = 'none'

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
}

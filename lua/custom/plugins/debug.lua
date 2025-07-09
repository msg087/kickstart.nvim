-- debug.lua

return {
  {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
    --
    'mfussenegger/nvim-dap-python',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_setup = true,
      -- see mason-nvim-dap README for more information
      handlers = {},
      ensure_installed = {
        'delve',
        'bash-debug-adapter',
        'debugpy',
      },
        }

  --   local function test_setup()
  -- print 'Setting up nvim-dap...'
  --   end

-- require('dap-python').setup(get_python_path())
local function get_python_path()
  local cwd = vim.fn.getcwd()
  local venv = cwd .. '/.venv/bin/python'
  if vim.fn.executable(venv) == 1 then
    print('Using .venv/bin/python')
    return venv
  else
    print('No .venv found!')
    return nil
  end
end

    --
    -- local function get_python_path()
    --   -- Check if the current directory has a .venv or venv folder
    --   local cwd = vim.fn.getcwd()
    --   if vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
    --     print('Using .venv/bin/python')
    --     return cwd .. '/.venv/bin/python'
    --   else
    --     print('no .venv found!!!')
    -- end
    -- end

--           -- Safe import of dap-python
--     local ok, dap_python = pcall(require, 'dap-python')
--     if ok then
--       dap_python.setup(get_python_path())
--         print('dap-python setup complete with ' .. get_python_path())
--
--       -- Refresh on DirChanged to pick up new venvs
--       vim.api.nvim_create_autocmd("DirChanged", {
--         callback = function()
--           dap_python.setup(get_python_path())
--         end
--       })
-- else
--       print('dap-python not found, skipping setup')
--     end

local ok, dap_python = pcall(require, 'dap-python')
if ok then
  local python_path = get_python_path()
  if python_path then
    dap_python.setup(python_path)
    print('dap-python setup complete with ' .. python_path)

    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        local new_path = get_python_path()
        if new_path then
          dap_python.setup(new_path)
        end
      end,
    })
  -- else
  --   print('Skipping dap-python setup: No virtual environment found.')
  end
-- else
--   print('dap-python not found, skipping setup')
end

    
--
-- vim.api.nvim_create_autocmd("DirChanged", {
--   callback = function()
--     require('dap-python').setup(get_python_path())
--   end,
-- })
--

    dap.adapters.bashdb = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
      name = 'bashdb',
    }

    dap.configurations.sh = {
      {
        type = 'bashdb',
        request = 'launch',
        name = 'Launch file',
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
        pathBashdbLib = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
        trace = true,
        file = '${file}',
        program = '${file}',
        cwd = '${workspaceFolder}',
        pathCat = 'cat',
        pathBash = '/bin/bash',
        pathMkfifo = 'mkfifo',
        pathPkill = 'pkill',
        args = {},
        env = {},
        terminalKind = 'integrated',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    -- vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    -- vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    -- vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    -- vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    -- vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    -- vim.keymap.set('n', '<leader>B', function()
    --   dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    -- end, { desc = 'Debug: Set Breakpoint' })
    vim.keymap.set('n', '<leader>ds', dap.continue, { desc = 'Debug: [s]tart/Continue' })
    vim.keymap.set('n', '<leader>dS', dap.continue, { desc = 'Debug: [S]tart/Continue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step [o]ver' })
    vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Debug: Step [O]ut' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()
  end,
  },
}

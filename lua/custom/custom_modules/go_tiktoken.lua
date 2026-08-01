local M = {}

local state = {
  win = nil,
  buf = nil,
  cursor = nil,
}

local function close_window()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  -- if state.cursor then
  --   vim.o.guicursor = state.cursor
  -- end

  state.win = nil
  state.buf = nil
  -- state.cursor = nil
end

local function center_output(output, width)
  local centered = {}

  for line in (output .. '\n'):gmatch '(.-)\n' do
    local plain = line:gsub('\27%[[0-9;]*m', '')
    local padding = math.max(0, math.floor((width - vim.fn.strdisplaywidth(plain)) / 2))

    table.insert(centered, string.rep(' ', padding) .. line)
  end

  return table.concat(centered, '\n')
end

local function open_float()
  state.cursor = vim.o.guicursor
  -- vim.api.nvim_set_hl(0, 'HiddenCursor', { link = 'Normal' })
  -- vim.o.guicursor = 'a:HiddenCursor'

  state.buf = vim.api.nvim_create_buf(false, true)

  -- local width = math.max(20, math.min(math.floor(vim.o.columns * 0.20), vim.o.columns - 4))
  -- local height = math.max(15, math.min(math.floor(vim.o.lines * 0.20), vim.o.lines - 4))
  local width = 20
  local height = 5

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = 'rounded',
    style = 'minimal',
    title = ' Go-Tiktoken ',
    title_pos = 'center',
  })

  vim.bo[state.buf].bufhidden = 'wipe'
  vim.bo[state.buf].swapfile = false

  local opts = { buffer = state.buf, silent = true, nowait = true }

  vim.keymap.set('n', 'q', close_window, opts)
  vim.keymap.set('n', '<Esc>', close_window, opts)

  return state.buf
end

local function run_go_tiktoken(args, cleanup)
  if vim.fn.executable 'go-tiktoken' == 0 then
    vim.notify('go-tiktoken not found in PATH', vim.log.levels.ERROR)
    return
  end

  local buf = open_float()
  local channel = vim.api.nvim_open_term(buf, {})
  -- function()
  --   vim.fn.getchar(-1, { cursor = 'hide' })
  -- end,
  -- })

  vim.system(args, { text = false }, function(result)
    vim.schedule(function()
      if cleanup then
        cleanup()
      end

      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      local output = result.stdout or ''

      if result.stderr and result.stderr ~= '' then
        output = output .. result.stderr
      end

      -- vim.api.nvim_chan_send(channel, output)
      local width = vim.api.nvim_win_get_width(state.win)
      vim.api.nvim_chan_send(channel, center_output(output, width))
      -- vim.api.nvim_chan_send(channel, vim.fn.getchar(-1, { cursor = 'hide' }))

      --attempt at hiding cursor
      -- vim.cmd 'redraw'

      -- close_window()
    end)
  end)
end

function M.file()
  vim.cmd 'write'
  run_go_tiktoken { 'go-tiktoken', vim.fn.expand '%:p' }
end

function M.selection()
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, '\n')

  local tmp = vim.fn.tempname()
  vim.fn.writefile(vim.split(text, '\n'), tmp)

  run_go_tiktoken({ 'go-tiktoken', tmp }, function()
    vim.fn.delete(tmp)
  end)
end

return M

-- local M = {}

-- local state = {
--   win = nil,
--   buf = nil,
-- }

-- local function close_window()
--   if state.win and vim.api.nvim_win_is_valid(state.win) then
--     vim.api.nvim_win_close(state.win, true)
--   end
--   state.win = nil
--   state.buf = nil
-- end

-- local function open_float()
--   state.buf = vim.api.nvim_create_buf(false, true)

--   local width = math.max(60, math.min(math.floor(vim.o.columns * 0.40), vim.o.columns - 4))
--   local height = math.max(15, math.min(math.floor(vim.o.lines * 0.40), vim.o.lines - 4))

--   state.win = vim.api.nvim_open_win(state.buf, true, {
--     relative = 'editor',
--     width = width,
--     height = height,
--     col = math.floor((vim.o.columns - width) / 2),
--     row = math.floor((vim.o.lines - height) / 2),
--     border = 'rounded',
--     style = 'minimal',
--     title = ' Go-Tiktoken ',
--     title_pos = 'center',
--   })

--   vim.bo[state.buf].bufhidden = 'wipe'
--   vim.bo[state.buf].swapfile = false

--   vim.keymap.set('n', 'q', close_window, {
--     buffer = state.buf,
--     silent = true,
--     nowait = true,
--   })
-- end

-- local function remove_process_exit_message(buf)
--   if not (buf and vim.api.nvim_buf_is_valid(buf)) then
--     return
--   end

--   vim.schedule(function()
--     if not vim.api.nvim_buf_is_valid(buf) then
--       return
--     end

--     vim.bo[buf].modifiable = true
--     local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--     local last = lines[#lines]
--     if last and last:match('^%[Process exited %d+%]$') then
--       vim.api.nvim_buf_set_lines(buf, #lines - 1, #lines, false, {})
--     end
--     vim.bo[buf].modifiable = false
--   end)
-- end

-- local function run_go_tiktoken(args)
--   if vim.fn.executable 'go-tiktoken' == 0 then
--     vim.notify('go-tiktoken not found in PATH', vim.log.levels.ERROR)
--     return
--   end

--   open_float()
--   vim.fn.termopen(args, {
--     on_exit = function()
--       remove_process_exit_message(state.buf)
--     end,
--   })
-- end

-- function M.file()
--   vim.cmd 'write'
--   run_go_tiktoken { 'go-tiktoken', vim.fn.expand '%:p' }
-- end

-- function M.selection()
--   local start_line = vim.fn.line "'<"
--   local end_line = vim.fn.line "'>"

--   local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
--   local text = table.concat(lines, '\n')

--   local tmp = vim.fn.tempname()
--   vim.fn.writefile(vim.split(text, '\n'), tmp)

--   run_go_tiktoken { 'go-tiktoken', tmp }
--   vim.fn.delete(tmp)
-- end

-- return M

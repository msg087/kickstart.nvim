local M = {}

-- Run tokuin on a file and return output
local function run_tokuin(target)
  if vim.fn.executable 'tokuin' == 0 then
    return "Error: 'tokuin' not found in PATH"
  end

  local cmd = 'tokuin --model gpt-4 ' .. target
  return vim.fn.system(cmd)
end

-- Floating window display
local function show_float(output)
  local buf = vim.api.nvim_create_buf(false, true)

  local lines = vim.split(output, '\n')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = 'rounded',
    style = 'minimal',
  })

  -- Optional: make it look nicer
  vim.bo[buf].filetype = 'markdown'
end

-- Public: current file
function M.file()
  vim.cmd 'write'
  local file = vim.fn.expand '%'
  local output = run_tokuin(file)
  show_float(output)
end

-- Public: visual selection
function M.selection()
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, '\n')

  local tmp = vim.fn.tempname()
  vim.fn.writefile(vim.split(text, '\n'), tmp)

  local output = run_tokuin(tmp)
  show_float(output)

  vim.fn.delete(tmp)
end

return M

local M = {}

local install_map = {
  jq = 'sudo apt install jq',
  xmllint = 'sudo apt install libxml2-utils',
  xmlstarlet = 'sudo apt install xmlstarlet',
  tidy = 'sudo apt install tidy',
}

local embedded_json_jq = [[
jq '
def trim:
  gsub("^\\s+"; "") | gsub("\\s+$"; "");

def looks_like_json:
  trim as $t
  | (
      ($t | startswith("{") and endswith("}"))
      or
      ($t | startswith("[") and endswith("]"))
      or
      ($t | startswith("\"{") and endswith("}\""))
      or
      ($t | startswith("\"[") and endswith("]\""))
    );

def maybe_fromjson:
  if type == "string" and looks_like_json
  then
    try fromjson catch .
  else
    .
  end;

walk(maybe_fromjson)
'
]]

local function executable_or_warn(bin)
  if vim.fn.executable(bin) == 1 then
    return true
  end

  local msg = bin .. ' not installed'

  if install_map[bin] then
    msg = msg .. '\nInstall with:\n' .. install_map[bin]
  end

  vim.notify(msg, vim.log.levels.ERROR, {
    title = 'Formatter Missing',
  })

  return false
end

-- local function make_formatter(bin, cmd)
--   return function()
--     if not executable_or_warn(bin) then
--       return
--     end

--     vim.cmd('%!' .. cmd)
--   end
-- end

local function filter_buffer(cmd)
  local input = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')

  local output = vim.fn.system(cmd, input)

  if vim.v.shell_error ~= 0 then
    vim.notify(output, vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, '\n'))
end

local function make_formatter(bin, cmd)
  return function()
    if not executable_or_warn(bin) then
      return
    end

    filter_buffer(cmd)
  end
end

M.format_json = make_formatter('jq', 'jq .')
M.format_escaped_json = make_formatter('jq', [[jq -r 'fromjson']])
M.expand_embedded_json = make_formatter('jq', embedded_json_jq)

--xml
M.format_xml = make_formatter('xmllint', 'xmllint --format -')
M.recover_xml = make_formatter('xmllint', 'xmllint --recover --format -')

return M

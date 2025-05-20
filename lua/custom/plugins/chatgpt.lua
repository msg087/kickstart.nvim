local api_key = nil
local fetch_cmd = os.getenv 'HOME' .. '/dotfiles/aws/fetch_openai_key.sh'

local function fetch_openai_key()
  -- print '[ChatGPT.nvim] Running fetch-openai-key...'

  local handle = io.popen(fetch_cmd)
  if not handle then
    print '[ChatGPT.nvim] Failed to open handle'
    return false
  end

  local result = handle:read '*a'
  handle:close()

  -- print('[ChatGPT.nvim] Raw result: ' .. string.format('%q', result))

  result = result and result:gsub('%s+$', '') -- trim trailing whitespace

  if result == '' then
    print '[ChatGPT.nvim] No key returned from fetch script.'
    return false
  end

  api_key = result
  -- print('[ChatGPT.nvim] Final command: ' .. string.format('echo %q', api_key))
  -- print '[ChatGPT.nvim] Successfully fetched key.'
  return true
end

return {
  {
    'jackMort/ChatGPT.nvim',
    cond = fetch_openai_key,
    config = function()
      -- print '[ChatGPT.nvim] Setting up plugin with api_key_cmd...'
      require('chatgpt').setup {
        api_key_cmd = string.format('echo %q', api_key),
      }
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },
}

local M = {}

local fetch_key_cmd = os.getenv 'HOME' .. '/dotfiles/aws/fetch_openai_key.sh'

function M.fetch_api_key(callback)
  local result_lines = {}

  vim.fn.jobstart(fetch_key_cmd, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if line and line ~= '' then
          table.insert(result_lines, line)
        end
      end
    end,

    on_exit = function(_, _, _)
      local key = table.concat(result_lines, ''):gsub('%s+$', '')
      if key == '' then
        print '[API Key Fetcher] No key returned from fetch script.'
        callback(nil)
      else
        -- print('[API Key Fetcher] Got key: ' .. key)
        callback(key)
      end
    end,
  })
end

return M

-- local M = {}

-- local fetch_key_cmd = os.getenv 'HOME' .. '/dotfiles/aws/fetch_openai_key.sh'

-- function M.fetch_api_key(callback)
--   local function on_exit(job_id, data, event)
--     local result = table.concat(data, '\n'):gsub('%s+$', '')
--     if result == '' then
--       print '[API Key Fetcher] No key returned from fetch script.'
--       callback(nil)
--     else
--       print('[API KEY]:' .. result)
--       callback(result)
--     end
--   end

--   vim.fn.jobstart(fetch_key_cmd, {
--     on_exit = on_exit,
--     stdout_buffered = true,
--     stderr_buffered = true,
--   })
-- end

-- return M

-- local M = {}
--
-- local fetch_key_cmd = os.getenv 'HOME' .. '/dotfiles/aws/fetch_openai_key.sh'
--
-- function M.fetch_api_key()
--   local handle = io.popen(fetch_key_cmd)
--   if not handle then
--     print '[API Key Fetcher] Failed to open handle'
--     return nil
--   end
--
--   local result = handle:read '*a'
--   handle:close()
--
--   if result == '' then
--     print '[API Key Fetcher] No key returned from fetch script.'
--     return nil
--   end
--
--   -- print('[API KEY]:' .. result)
--   -- print('[API KEY] quoted:' .. result)
--   -- print('[API KEY] Final command: ' .. string.format('echo %q', result))
--   -- api_key = string.format('echo %q', result)
--   api_key = result:gsub('%s+$', '')
--   print('[API KEY]:' .. api_key)
--   return api_key
-- end
--
-- return M

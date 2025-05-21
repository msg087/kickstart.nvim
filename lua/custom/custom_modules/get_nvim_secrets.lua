local function fetch_api_keys()
  local handle = io.popen 'bash /path/to/fetch_openai_key.sh all'
  local result = handle:read '*a'
  handle:close()
  return result
end

local function setup_plugins()
  local api_keys = fetch_api_keys()
  -- Use api_keys in your plugin setup
  -- For example, setting up OpenAI plugin
  require('openai').setup {
    api_key = os.getenv 'OPENAI_API_KEY',
  }
end

-- Lazy load or async setup
vim.defer_fn(setup_plugins, 100)

-- make this into a nvim lua module instead of just functions.this should be using lua to parse the json and creating a lua table for those that i can read with my plugins.

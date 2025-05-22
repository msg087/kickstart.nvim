-- local api_key_fetcher = require 'custom.custom_modules.get_openai_key'
-- local openai_key = api_key_fetcher.fetch_api_key()

-- local function fetch_openai_key()
--   -- print '[ChatGPT.nvim] Running fetch-openai-key...'
--
--   local handle = io.popen(fetch_cmd)
--   if not handle then
--     print '[ChatGPT.nvim] Failed to open handle'
--     return false
--   end
--
--   local result = handle:read '*a'
--   handle:close()
--
--   -- print('[ChatGPT.nvim] Raw result: ' .. string.format('%q', result))
--
--   -- result = result and result:gsub('%s+$', '') -- trim trailing whitespace
--
--   if result == '' then
--     print '[ChatGPT.nvim] No key returned from fetch script.'
--     return false
--   end
--
--   api_key = result
--   -- print('[ChatGPT.nvim] Final command: ' .. string.format('echo %q', api_key))
--   -- print '[ChatGPT.nvim] Successfully fetched key.'
--   return true
-- end
--
return {
  {
    'jackMort/ChatGPT.nvim',
    cond = fetch_openai_key,
    config = function()
      -- print '[ChatGPT.nvim] Setting up plugin with api_key_cmd...'
      require('chatgpt').setup {
        -- api_key_cmd =  string.format('echo %q', openai_key)
        -- api_key_cmd = 'op exec fetch_cmd --no-newline',

        openai_params = {
          -- api_key = openai_key,
          -- NOTE: model can be a function returning the model name
          -- this is useful if you want to change the model on the fly
          -- using commands
          -- Example:
          -- model = function()
          --     if some_condition() then
          --         return "gpt-4-1106-preview"
          --     else
          --         return "gpt-3.5-turbo"
          --     end
          -- end,
          model = 'gpt-4.1-mini-2025-04-14', --0.40 in, 1.60 out
          -- model = "o3-mini-2025-01-31", -- 1.10 in, 4.40 out
          -- model = "gpt-4-1106-preview",
          -- model = 'gpt-4o-2024-08-06', --2.5 in, 10 out per million
          -- model = "gpt-4.1-2025-04-14", --2.00 in, 8.00 out
          -- model = "codex-mini-latest", --1.50 in, 6.00 out
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4095,
          temperature = 0.2,
          top_p = 0.1,
          n = 1,
        },
      }

      -- print('[ChatGPT.nvim] without echo command: ' .. api_key)
      -- print('[ChatGPT.nvim] Final command: ' .. string.format('echo %q', api_key))
      require('which-key').add {
        { '<leader>gg', '<cmd>ChatGPT<CR>', desc = 'ChatGPT', mode = 'n' },
        { '<leader>ge', '<cmd>ChatGPTEditWithInstruction<CR>', desc = 'Edit with instruction', mode = { 'n', 'v' } },
        { '<leader>ggc', '<cmd>ChatGPTRun grammar_correction<CR>', desc = 'Grammar Correction', mode = { 'n', 'v' } },
        { '<leader>gt', '<cmd>ChatGPTRun translate<CR>', desc = 'Translate', mode = { 'n', 'v' } },
        { '<leader>gk', '<cmd>ChatGPTRun keywords<CR>', desc = 'Keywords', mode = { 'n', 'v' } },
        { '<leader>gd', '<cmd>ChatGPTRun docstring<CR>', desc = 'Docstring', mode = { 'n', 'v' } },
        { '<leader>ga', '<cmd>ChatGPTRun add_tests<CR>', desc = 'Add Tests', mode = { 'n', 'v' } },
        { '<leader>go', '<cmd>ChatGPTRun optimize_code<CR>', desc = 'Optimize Code', mode = { 'n', 'v' } },
        { '<leader>gs', '<cmd>ChatGPTRun summarize<CR>', desc = 'Summarize', mode = { 'n', 'v' } },
        { '<leader>gf', '<cmd>ChatGPTRun fix_bugs<CR>', desc = 'Fix Bugs', mode = { 'n', 'v' } },
        { '<leader>gx', '<cmd>ChatGPTRun explain_code<CR>', desc = 'Explain Code', mode = { 'n', 'v' } },
        { '<leader>gr', '<cmd>ChatGPTRun roxygen_edit<CR>', desc = 'Roxygen Edit', mode = { 'n', 'v' } },
        { '<leader>gl', '<cmd>ChatGPTRun code_readability_analysis<CR>', desc = 'Code Readability', mode = { 'n', 'v' } },
      }
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'folke/trouble.nvim', --optional
      'nvim-telescope/telescope.nvim',
    },
  },
  -- {
  --   'jackMort/ChatGPT.nvim',
  --   cond = fetch_openai_key,
  --   config = function()
  --     -- print '[ChatGPT.nvim] Setting up plugin with api_key_cmd...'
  --     require('chatgpt').setup {
  --       -- api_key_cmd =  string.format('echo %q', openai_key)
  --       -- api_key_cmd = 'op exec fetch_cmd --no-newline',

  --       openai_params = {
  --         -- api_key = openai_key,
  --         -- NOTE: model can be a function returning the model name
  --         -- this is useful if you want to change the model on the fly
  --         -- using commands
  --         -- Example:
  --         -- model = function()
  --         --     if some_condition() then
  --         --         return "gpt-4-1106-preview"
  --         --     else
  --         --         return "gpt-3.5-turbo"
  --         --     end
  --         -- end,
  --         model = 'gpt-4.1-mini-2025-04-14', --0.40 in, 1.60 out
  --         -- model = "o3-mini-2025-01-31", -- 1.10 in, 4.40 out
  --         -- model = "gpt-4-1106-preview",
  --         -- model = 'gpt-4o-2024-08-06', --2.5 in, 10 out per million
  --         -- model = "gpt-4.1-2025-04-14", --2.00 in, 8.00 out
  --         -- model = "codex-mini-latest", --1.50 in, 6.00 out
  --         frequency_penalty = 0,
  --         presence_penalty = 0,
  --         max_tokens = 4095,
  --         temperature = 0.2,
  --         top_p = 0.1,
  --         n = 1,
  --       },
  --     }

  --     -- print('[ChatGPT.nvim] without echo command: ' .. api_key)
  --     -- print('[ChatGPT.nvim] Final command: ' .. string.format('echo %q', api_key))
  --     require('which-key').add {
  --       { '<leader>gg', '<cmd>ChatGPT<CR>', desc = 'ChatGPT', mode = 'n' },
  --       { '<leader>ge', '<cmd>ChatGPTEditWithInstruction<CR>', desc = 'Edit with instruction', mode = { 'n', 'v' } },
  --       { '<leader>ggc', '<cmd>ChatGPTRun grammar_correction<CR>', desc = 'Grammar Correction', mode = { 'n', 'v' } },
  --       { '<leader>gt', '<cmd>ChatGPTRun translate<CR>', desc = 'Translate', mode = { 'n', 'v' } },
  --       { '<leader>gk', '<cmd>ChatGPTRun keywords<CR>', desc = 'Keywords', mode = { 'n', 'v' } },
  --       { '<leader>gd', '<cmd>ChatGPTRun docstring<CR>', desc = 'Docstring', mode = { 'n', 'v' } },
  --       { '<leader>ga', '<cmd>ChatGPTRun add_tests<CR>', desc = 'Add Tests', mode = { 'n', 'v' } },
  --       { '<leader>go', '<cmd>ChatGPTRun optimize_code<CR>', desc = 'Optimize Code', mode = { 'n', 'v' } },
  --       { '<leader>gs', '<cmd>ChatGPTRun summarize<CR>', desc = 'Summarize', mode = { 'n', 'v' } },
  --       { '<leader>gf', '<cmd>ChatGPTRun fix_bugs<CR>', desc = 'Fix Bugs', mode = { 'n', 'v' } },
  --       { '<leader>gx', '<cmd>ChatGPTRun explain_code<CR>', desc = 'Explain Code', mode = { 'n', 'v' } },
  --       { '<leader>gr', '<cmd>ChatGPTRun roxygen_edit<CR>', desc = 'Roxygen Edit', mode = { 'n', 'v' } },
  --       { '<leader>gl', '<cmd>ChatGPTRun code_readability_analysis<CR>', desc = 'Code Readability', mode = { 'n', 'v' } },
  --     }
  --   end,
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'folke/trouble.nvim', --optional
  --     'nvim-telescope/telescope.nvim',
  --   },
  -- },
}

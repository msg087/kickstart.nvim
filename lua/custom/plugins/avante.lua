-- local api_key_fetcher = require 'custom.custom_modules.get_openai_key'
-- local openai_key = api_key_fetcher.fetch_api_key()
-- vim.env.OPENAI_API_KEY = require('custom.custom_modules.get_openai_key').fetch_api_key()
require('custom.custom_modules.get_openai_key').fetch_api_key(function(api_key)
  if api_key then
    vim.env.OPENAI_API_KEY = api_key
  end
end)

return {

  {

    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!

    keys = {
      {
        '<leader>a+',
        function()
          local tree_ext = require 'avante.extensions.nvim_tree'
          tree_ext.add_file()
        end,
        desc = 'Select file in NvimTree',
        ft = 'NvimTree',
      },
      {
        '<leader>a-',
        function()
          local tree_ext = require 'avante.extensions.nvim_tree'
          tree_ext.remove_file()
        end,
        desc = 'Deselect file in NvimTree',
        ft = 'NvimTree',
      },
    },

    config = function()
      local avante = require 'avante'

      avante.setup {
        provider = 'openai',
        openai = {
          endpoint = 'https://api.openai.com/v1',
          model = 'gpt-4o-mini-2024-07-18',
          -- model = 'o3-mini-2025-01-31',
          -- model = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
          timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
          temperature = 0,
          max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
          -- api_key = openai_key,
          --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models

          -- selector = {
          --   exclude_auto_select = { 'NvimTree' },
          -- },
        },

        disabled_tools = { --will cause issues with mcphub
          'list_files', -- Built-in file operations
          'search_files',
          'read_file',
          'create_file',
          'rename_file',
          'replace_in_file',
          'delete_file',
          'create_dir',
          'rename_dir',
          'delete_dir',
          'bash', -- Built-in terminal access
        },

        selector = {
          exclude_auto_select = { 'NvimTree' },
        },

        system_prompt = function()
          local hub = require('mcphub').get_hub_instance()
          return hub and hub:get_active_servers_prompt() or ''
        end,
        custom_tools = function()
          return {
            require('mcphub.extensions.avante').mcp_tool(),
          }
        end,

        --         custom_tools = function()
        --           local tools = {}
        --           local hub = require('mcphub').get_hub_instance()
        --           if not hub or not hub.servers then
        --             return tools
        --           end

        --           for _, server in ipairs(hub.servers) do
        --             if server.prompts then
        --               for _, prompt in ipairs(server.prompts) do
        --                 local command_name = '@mcp:' .. server.name .. ':' .. prompt.name
        --                 table.insert(tools, {
        --                   name = command_name,
        --                   description = prompt.description or 'MCP Prompt',
        --                   handler = function(input)
        --                     return server:run(prompt.name, input)
        --                   end,
        --                 })
        --               end
        --             end
        --           end

        --           return tools
        --         end,

        -- custom_tools = function()
        --   local hub = require('mcphub').get_hub_instance()
        --   local tools = {}
        --
        --   for _, server in ipairs(hub.servers or {}) do
        --     if server.slash_commands then
        --       table.insert(tools, {
        --         id = server.name:gsub('%s+', '_'):lower(),
        --         name = server.name,
        --         vim.print('server name in for loop:' .. name),
        --         description = server.description or 'MCP Tool',
        --         handler = function(input)
        --           return server:run(input)
        --         end,
        --       })
        --     end
        --   end
        --
        --   vim.schedule(function()
        --     vim.print 'Loaded Avante MCP Tools:'
        --     vim.print(tools)
        --   end)
        --   return tools
        -- end,
        -- return {
        --     require("mcphub.extensions.avante").mcp_tool(),
        -- }
        -- end,
      }
    end,
    -- rag_service = {
    --   enabled = false, -- Enables the RAG service
    --   host_mount = os.getenv("HOME"), -- Host mount path for the rag service
    --   provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
    --   llm_model = "", -- The LLM model to use for RAG service
    --   embed_model = "", -- The embedding model to use for RAG service
    --   endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
    -- },
    --
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      { 'ravitemer/mcphub.nvim', lazy = false },
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}

-- keys = {
--   {
--     '<leader>a+',
--     function()
--       local tree_ext = require 'avante.extensions.nvim_tree'
--       tree_ext.add_file()
--     end,
--     desc = 'Select file in NvimTree',
--     ft = 'NvimTree',
--   },
--   {
--     '<leader>a-',
--     function()
--       local tree_ext = require 'avante.extensions.nvim_tree'
--       tree_ext.remove_file()
--     end,
--     desc = 'Deselect file in NvimTree',
--     ft = 'NvimTree',
--   },
-- },
--
--
--
--

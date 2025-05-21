-- local api_key_fetcher = require 'custom.custom_modules.get_openai_key'
-- local openai_key = api_key_fetcher.fetch_api_key()
-- vim.env.OPENAI_API_KEY = require('custom.custom_modules.get_openai_key').fetch_api_key()
require('custom.custom_modules.get_openai_key').fetch_api_key(function(api_key)
  if api_key then
    vim.env.OPENAI_API_KEY = api_key
  end
end)

return {

  -- {
  --   'ravitemer/mcphub.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   build = 'bundled_build.lua', -- Bundles `mcp-hub` binary along with the neovim plugin
  --   config = function()
  --     require('mcphub').setup {
  --       use_bundled_binary = true, -- Use local `mcp-hub` binary
  --       extensions = {
  --         avante = {
  --           make_slash_commands = true, -- make /slash commands from MCP server prompts
  --         },
  --       },
  --     }
  --   end,
  --   -- build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
  --   -- config = function()
  --   -- require('mcphub').setup()
  --   -- require('mcphub').setup {
  --   -- end,
  -- },
  --
  {
    'ravitemer/mcphub.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    build = 'npm install -g mcp-hub@latest',
    config = function()
      require('mcphub').setup {
        port = 3000,
        config = vim.fn.expand '~/.config/nvim/mcpservers.json',
        log = {
          level = vim.log.levels.WARN,
          to_file = true,
        },
        extensions = {
          avante = {
            make_slash_commands = true,
          },
        },
        on_ready = function()
          vim.notify 'MCP Hub is online!'
        end,
      }
    end,
  },

  {

    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
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
    opts = {
      -- add any opts here
      -- for example
      provider = 'openai',
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0,
        max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        -- api_key = openai_key,
        --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },

      -- selector = {
      --   exclude_auto_select = { 'NvimTree' },
      -- },

      system_prompt = function()
        local hub = require('mcphub').get_hub_instance()
        return hub:get_active_servers_prompt()
      end,

      -- custom_tools = {
      --   require('mcphub.extensions.avante').mcp_tool('planning', function()
      --     return require('avante.utils').get_project_root()
      --   end),
      -- },
      -- custom_tools = {
      --   require('mcphub.extensions.avante').mcp_tool(),
      -- },

      -- rag_service = {
      --   enabled = false, -- Enables the RAG service
      --   host_mount = os.getenv("HOME"), -- Host mount path for the rag service
      --   provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
      --   llm_model = "", -- The LLM model to use for RAG service
      --   embed_model = "", -- The embedding model to use for RAG service
      --   endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
      -- },
    },
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

  --    {
  --     "olimorris/codecompanion.nvim",
  --     dependencies = {
  --       { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  --       { "nvim-lua/plenary.nvim" },
  --       -- Test with blink.cmp
  --       {
  --         "saghen/blink.cmp",
  --         lazy = false,
  --         version = "*",
  --         opts = {
  --           keymap = {
  --             preset = "enter",
  --             ["<S-Tab>"] = { "select_prev", "fallback" },
  --             ["<Tab>"] = { "select_next", "fallback" },
  --           },
  --           cmdline = { sources = { "cmdline" } },
  --           sources = {
  --             default = { "lsp", "path", "buffer", "codecompanion" },
  --           },
  --         },
  --       },
  --       -- Test with nvim-cmp
  --       -- { "hrsh7th/nvim-cmp" },
  --     },
  --     opts = {
  --       --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
  --       strategies = {
  --         --NOTE: Change the adapter as required
  --         chat = { adapter = "copilot" },
  --         inline = { adapter = "copilot" },
  --       },
  --       opts = {
  --         log_level = "DEBUG",
  --       },
  --     },
  --   },
  -- }
  --
  -- require("lazy.minit").repro({ spec = plugins })
  --
  -- -- Setup Tree-sitter
  -- local ts_status, treesitter = pcall(require, "nvim-treesitter.configs")
  -- if ts_status then
  --   treesitter.setup({
  --     ensure_installed = { "lua", "markdown", "markdown_inline", "yaml" },
  --     highlight = { enable = true },
  --   })
  -- end

  -- Setup nvim-cmp
  -- local cmp_status, cmp = pcall(require, "cmp")
  -- if cmp_status then
  --   cmp.setup({
  --     mapping = cmp.mapping.preset.insert({
  --       ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  --       ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --       ["<C-Space>"] = cmp.mapping.complete(),
  --       ["<C-e>"] = cmp.mapping.abort(),
  --       ["<CR>"] = cmp.mapping.confirm({ select = true }),
  --       -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --     }),
  --   })
  -- end
}

return {
  {
    'ravitemer/mcphub.nvim',
    lazy = false,
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally

    config = function()
      require('mcphub').setup {
        --- `mcp-hub` binary related options-------------------
        config = vim.fn.expand '~/dotfiles/nvim/.config/nvim/mcphub/servers.json', -- Absolute path to MCP Servers config file (will create if not exists)
        port = 37373, -- The port `mcp-hub` server listens to
        shutdown_delay = 60 * 10 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 10 minutes)
        use_bundled_binary = false, -- Use local `mcp-hub` binary (set this to true when using build = "bundled_build.lua")

        ---Chat-plugin related options-----------------
        auto_approve = true, -- Auto approve mcp tool calls
        auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
        },

        --- Plugin specific options-------------------
        native_servers = {}, -- add your custom lua native servers here
        ui = {
          window = {
            width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            relative = 'editor',
            zindex = 50,
            border = 'rounded', -- "none", "single", "double", "rounded", "solid", "shadow"
          },
          wo = { -- window-scoped options (vim.wo)
            winhl = 'Normal:MCPHubNormal,FloatBorder:MCPHubBorder',
          },
        },

        -- log = {
        --   level = vim.log.levels.DEBUG,
        --   to_file = true,
        -- },

        on_ready = function(hub)
          -- vim.schedule(function()
          --   local prompt = require('mcphub.api').get_active_servers_prompt()
          --   vim.notify('MCP Active Servers:\n' .. prompt, vim.log.levels.INFO, { title = 'MCPHub' })
          -- end)
        end,
        require('lualine').setup {
          sections = {
            lualine_x = {
              -- Other lualine components in "x" section
              { require 'mcphub.extensions.lualine' },
            },
          },
        },
      }
    end,
  },
}

-- on_ready = function(hub)
--   vim.api.nvim_create_user_command('MCPServers', function()
--     for _, server in ipairs(hub.servers or {}) do
--       vim.print {
--         name = server.name,
--         description = server.description,
--         url = server.url,
--         slash = server.slash_commands,
--       }
--     end
--   end, {})

--   vim.notify('MCPServers command is ready!', vim.log.levels.INFO)

--   -- Auto print to message area on startup
--   if hub.servers and #hub.servers > 0 then
--     vim.schedule(function()
--       for _, server in ipairs(hub.servers) do
--         vim.notify(string.format('MCP Server: %s (%s)', server.name, server.url), vim.log.levels.INFO, { title = 'MCPHub' })
--       end
--     end)
--   else
--     vim.notify('MCPHub started but no servers were loaded.', vim.log.levels.WARN, { title = 'MCPHub' })
--   end
-- end,
-- on_error = function(err)
--   -- Called on errors
-- end,
-- log = {
--   level = vim.log.levels.WARN,
--   to_file = false,
--   file_path = nil,
--   prefix = 'MCPHub',
-- },
-- }

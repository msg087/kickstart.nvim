-- ~/.config/nvim/lua/custom/print_mcp_servers.lua
local M = {}

M.print_servers = function()
  local ok, mcphub = pcall(require, 'mcphub')
  if not ok then
    vim.notify('mcphub not loaded', vim.log.levels.ERROR)
    return
  end

  local hub = mcphub.get_hub_instance()
  if not hub or not hub.servers then
    vim.notify('mcphub hub instance is empty or not initialized', vim.log.levels.WARN)
    return
  end

  vim.notify('Printing MCP servers...', vim.log.levels.INFO)
  for _, server in ipairs(hub.servers) do
    vim.print {
      name = server.name,
      description = server.description,
      url = server.url,
      slash = server.slash_commands,
    }
  end
end

M.print_server_tools = function()
  local ok, mcphub = pcall(require, 'mcphub')
  if not ok then
    vim.notify('mcphub not loaded', vim.log.levels.ERROR)
    return
  end

  local hub = mcphub.get_hub_instance()
  if not hub or not hub.servers then
    vim.notify('mcphub is not initialized', vim.log.levels.WARN)
    return
  end

  for _, server in ipairs(hub.servers) do
    vim.print {
      name = server.name,
      description = server.description,
      tool_type = server.tool_type,
      slash_commands = server.slash_commands,
      url = server.url,
    }
  end
end

return M

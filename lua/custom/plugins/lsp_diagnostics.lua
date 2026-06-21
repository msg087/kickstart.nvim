local lsp_diag = require 'custom.custom_modules.lsp_diagnostics'

vim.api.nvim_create_user_command('LspDiagnostics', function()
  lsp_diag.open()
end, {})

return {}

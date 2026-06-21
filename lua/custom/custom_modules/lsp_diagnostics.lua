local M = {}

local function sev_name(sev)
  return ({
    [vim.diagnostic.severity.ERROR] = 'ERROR',
    [vim.diagnostic.severity.WARN] = 'WARN',
    [vim.diagnostic.severity.INFO] = 'INFO',
    [vim.diagnostic.severity.HINT] = 'HINT',
  })[sev] or tostring(sev)
end

function M.open(opts)
  opts = opts or {}

  local source_buf = opts.bufnr or vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(source_buf)

  if #diagnostics == 0 then
    vim.notify(
      ('No Lsp Diagnostics in %s'):format(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(source_buf), ':t')),
      vim.log.levels.INFO,
      { title = 'LspDiagnostics', timeout = 3000 }
    )
    return
  end

  local lines = {
    '# Diagnostics scratch',
    '',
    ('source buffer: %d'):format(source_buf),
    ('file: %s'):format(vim.api.nvim_buf_get_name(source_buf)),
    '',
  }

  for i, d in ipairs(diagnostics) do
    local ns = d.namespace and vim.diagnostic.get_namespace(d.namespace) or {}
    local lnum = (d.lnum or 0) + 1
    local col = (d.col or 0) + 1
    local end_lnum = (d.end_lnum or d.lnum or 0) + 1
    local end_col = (d.end_col or d.col or 0) + 1

    table.insert(lines, ('## %d. [%s] %s'):format(i, sev_name(d.severity), d.source or ns.name or 'unknown'))
    table.insert(lines, ('range: %d:%d -> %d:%d'):format(lnum, col, end_lnum, end_col))
    table.insert(lines, ('code: %s'):format(d.code or ''))
    table.insert(lines, '')
    table.insert(lines, d.message or '')
    table.insert(lines, '')

    local related = d.user_data and d.user_data.lsp and d.user_data.lsp.relatedInformation

    if related then
      table.insert(lines, 'related:')
      for _, r in ipairs(related) do
        local loc = r.location or {}
        local uri = loc.uri or ''
        local range = loc.range or {}
        local start = range.start or {}

        table.insert(lines, ('- %s:%s:%s %s'):format(uri:gsub('^file://', ''), (start.line or 0) + 1, (start.character or 0) + 1, r.message or ''))
      end
      table.insert(lines, '')
    end
  end

  local scratch = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(scratch, 'lsp-diagnostics-scratch')
  vim.api.nvim_buf_set_lines(scratch, 0, -1, false, lines)

  vim.bo[scratch].buftype = 'nofile'
  vim.bo[scratch].bufhidden = 'wipe'
  vim.bo[scratch].swapfile = false
  vim.bo[scratch].filetype = 'markdown'
  vim.bo[scratch].modifiable = true

  vim.cmd 'botright split'
  vim.api.nvim_win_set_buf(0, scratch)
end

return M

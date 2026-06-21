-- look for xml like go tmpl and set file type
local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gotexttmpl',
    callback = function(args)
      local text = table.concat(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false), '\n')

      if text:match '^%s*<[%w_%-]+>' and text:match '</[%w_%-]+>%s*$' then
        -- vim.notify('before: ' .. vim.bo[args.buf].filetype)
        -- vim.notify('Setting to xml ' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ':t'))

        vim.bo[args.buf].filetype = 'xml'

        vim.schedule(function()
          vim.api.nvim_buf_call(args.buf, function()
            vim.cmd 'setfiletype xml'
          end)
        end)

        -- vim.defer_fn(function()
        --   vim.notify('syntax later = ' .. vim.bo[args.buf].syntax)
        -- end, 200)
      end
    end,
  })
end

return M

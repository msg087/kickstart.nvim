local highlight_group = vim.api.nvim_create_augroup('AutoHighlight', { clear = true })
local is_highlighting = false

local function toggle_highlight()
  if is_highlighting then
    -- Disable highlighting
    vim.api.nvim_clear_autocmds { group = highlight_group }
    vim.o.updatetime = 4000 -- Restore default `updatetime` value
    vim.cmd [[let @/ = '']]
    print 'Highlight current word: OFF'
    is_highlighting = false
  else
    -- Enable highlighting
    vim.api.nvim_create_autocmd('CursorHold', {
      group = highlight_group,
      callback = function()
        local word = vim.fn.expand '<cword>'
        if word ~= '' then
          vim.cmd("let @/ = '\\V\\<" .. vim.fn.escape(word, '\\') .. "\\>'")
        end
      end,
    })
    vim.o.updatetime = 500 -- Faster updates for highlighting
    print 'Highlight current word: ON'
    is_highlighting = true
  end
end

-- Map <leader>* to toggle highlighting
vim.keymap.set('n', '<leader>*', toggle_highlight, { noremap = true, silent = true })

return {}

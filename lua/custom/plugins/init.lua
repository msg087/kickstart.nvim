-- function MyFoldtext()
--   local text = vim.treesitter.foldtext()
--
--   -- local n_lines = vim.v.foldend - vim.v.foldstart
--   local n_line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
--   local text_lines = ' lines'
--
--   if n_lines == 1 then
--     text_lines = ' line'
--   end
--
--   table.insert(text, { ' - ' .. n_lines .. text_lines, { 'Folded' } })
--
--   return text
-- end
-- vim.opt.foldtext = 'v:lua.MyFoldtext()'

-- vim.api.nvim_create_autocmd('BufEnter', {
--   callback = function()
--     if vim.opt.foldmethod:get() == 'expr' then
--       vim.schedule(function()
--         vim.opt.foldmethod = 'expr'
--       end)
--     end
--   end,
-- })

-- local function get_custom_foldtext(foldtxt_suffix, foldstart)
--   local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
--   return {
--     { line, 'Normal' },
--     foldtxt_suffix,
--   }
-- end
--
-- _G.get_custom_foldtext = function()
--   local foldstart = vim.v.foldstart
--   local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
--   local foldtxt_suffix = get_custom_foldtxt_suffix(foldstart)
--   return {
--     { line, 'Normal' },
--     foldtxt_suffix,
--   }
-- end
--
-- "n   ^f.<80><fd>5f <80><fd>5ea (NOLOCK)^[^j

-- Function to execute the macro
-- local function execute_macro()
--   -- Convert the macro to a string with escape sequences
--   local macro = 'n ^f.<Esc>5f <Esc>5ea (NOLOCK)<Esc><C-j>'

--   -- Use vim.api.nvim_replace_termcodes to handle special keys
--   local keys = vim.api.nvim_replace_termcodes(macro, true, false, true)

--   -- Feed the keys into Neovim
--   vim.api.nvim_feedkeys(keys, 'n', false)
-- end

-- Map the function to a key combination, e.g., <leader>m
-- vim.api.nvim_set_keymap('n', '<leader>Sn', 'n ^f.<Esc>5f <Esc>5ea (NOLOCK)<Esc><C-j>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Sn', '^f.<Esc>f <Esc>ea (NOLOCK)<Esc>^<C-j>', {
  --NOTE: this needs to have an alias on the table, otherwise the find space wont find one
  desc = 'add [N]OLOCK',
  noremap = true,
  silent = true,
  expr = false,
})

-- -- Use spaces instead of tabs in Go files
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "go",
--   callback = function()
--     vim.bo.expandtab = true     -- use spaces, not tabs
--     vim.bo.shiftwidth = 4       -- indentation size
--     vim.bo.tabstop = 4          -- number of spaces per tab
--     vim.bo.softtabstop = 4
--   end,
-- })

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'go',
--   callback = function()
--     vim.opt_local.expandtab = true
--     vim.opt_local.shiftwidth = 2
--     vim.opt_local.softtabstop = 2
--   end,
-- })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'json',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

local function get_custom_foldtxt_suffix(foldstart)
  local fold_suffix_str = string.format('  %s [%s lines]', '┉', vim.v.foldend - foldstart + 1)
  return { fold_suffix_str, 'Folded' }
end

local function get_custom_foldtext(foldtxt_suffix, foldstart)
  local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
  return {
    { line, 'Normal' },
    foldtxt_suffix,
  }
end

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

-- local function get_custom_foldtxt_suffix(foldstart)
--   local fold_suffix_str = string.format('  %s [%s lines]', '┉', vim.v.foldend - foldstart + 1)
--   return { fold_suffix_str, 'Folded' }
-- end

-- _G.get_custom_foldtext = function()
--   local foldstart = vim.v.foldstart
--   local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)[1]
--   local foldtxt_suffix = get_custom_foldtxt_suffix(foldstart)
--   return {
--     { line, 'Normal' },
--     foldtxt_suffix,
--   }
-- end

--
--
--
--
-- Prevent LSP crash from non-serializable `get_language_id`
local orig_start_client = vim.lsp.start_client

vim.lsp.start_client = function(config)
  if config and type(config.get_language_id) == 'function' then
    print '[LSP Patch] Removing non-serializable `get_language_id`'
    config.get_language_id = nil
  end
  return orig_start_client(config)
end

--
--
--
_G.get_foldtext = function()
  local foldstart = vim.v.foldstart
  local ts_foldtxt = vim.treesitter.foldtext()
  local foldtxt_suffix = get_custom_foldtxt_suffix(foldstart)

  if type(ts_foldtxt) == 'string' then
    return get_custom_foldtext(foldtxt_suffix, foldstart)
  end

  table.insert(ts_foldtxt, foldtxt_suffix)
  return ts_foldtxt
end

vim.opt.foldmethod = 'expr'
vim.opt.foldlevel = 50
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.opt.foldtext = 'get_custom_foldtext()'
-- vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'

-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldtext = 'lua.custom.plugins.test_folding_treesitter.'
-- vim.opt.foldtext = 'v:'
-- vim.opt.foldtext = 'nvim_treesitter.foldtext()'
-- vim.cmd [[ set nofoldenable]]
-- {
--   function()
--     vim.opt.foldmethod = 'expr'
--     --     --     vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
--     --     --     vim.opt.foldtext = 'nvim_treesitter.foldtext()'
--     --     --     vim.cmd [[ set nofoldenable]]
--     --     --
--     --     --     -- vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--     --     --     -- vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'
--   end,

return {
  -- {
  --   config = function()
  --     require('lua.custom.plugins.test_folding_treesitter').setup()
  --   end,
  -- },
  --
  --
  --
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- optional, for file icons
    config = function()
      require('lualine').setup()
    end,
  },

  { vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true }) },
  { 'wakatime/vim-wakatime', lazy = false },

  {
    -- comment toggle
    -- consider terrortylor/nvim-comment as well
    'tpope/vim-commentary',
  },
  -- -- Database
  { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  -- { 'tpope/vim-dadbod', lazy = true },
  { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  {

    'kristijanhusak/vim-dadbod-ui',
    lazy = true,
    opts = {
      db_ui_execute_on_save = false,
    },
    -- }
    dependencies = {
      { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    config = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
    end,
  },

  --   {
  --   'nvim-lua/plenary.nvim',  -- Any already-installed plugin
  --   name = 'go-formatting',   -- optional label
  --   config = function()
  --     -- Format on save for Go files
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       pattern = "*.go",
  --       callback = function()
  --         vim.lsp.buf.format({ async = false })
  --       end,
  --     })
  --
  --     -- Manual <leader>f formatting
  --     vim.keymap.set('n', '<leader>f', function()
  --       vim.lsp.buf.format({ async = true })
  --     end, { desc = 'Format buffer' })
  --   end,
  -- },

  -- {
  -- -- No plugin needed since you're just running config
  -- -- You can name it or leave it anonymous
  -- name = "go-formatting", -- optional

  -- config = function()
  --   -- Format on save for Go files
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     pattern = "*.go",
  --     callback = function()
  --       vim.lsp.buf.format({ async = false })
  --     end,
  --   })

  --   -- Manual format with <leader>f
  --   vim.keymap.set('n', '<leader>f', function()
  --     vim.lsp.buf.format({ async = true })
  --   end, { desc = 'Format buffer' })
  -- end,
  -- },

  {
    'ThePrimeagen/vim-be-good',
    lazy = true,
  },
  -- { 'Mofiqul/vscode.nvim' },

  -- {
  --   'https://github.com/jamestthompson3/nvim-remote-containers',
  --   lazy = true,
  -- },
  -- {
  --   'https://codeberg.org/esensar/nvim-dev-container',
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  --   lazy = true,
  -- },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }

      -- " normal/insert
      -- <Plug>MarkdownPreview
      -- <Plug>MarkdownPreviewStop
      -- <Plug>MarkdownPreviewToggle
      --
      -- -- " example
      -- nmap <C-s> <Plug>MarkdownPreview
      -- nmap <M-s> <Plug>MarkdownPreviewStop
      -- nmap <C-p> <Plug>MarkdownPreviewToggle
      --
    end,
    ft = { 'markdown' },
  },

  {
    -- test for mcp servers
    vim.api.nvim_create_user_command('MCPServers', function()
      require('custom.custom_modules.print_mcp_servers').print_servers()
    end, {}),

    vim.api.nvim_create_user_command('MCPTools', function()
      require('custom.custom_modules.print_mcp_servers').print_server_tools()
    end, {}),
  },

  -- {
  --   -- Use spaces instead of tabs in Go files
  -- vim.api.nvim_create_autocmd("FileType", {
  -- pattern = "go",
  -- callback = function()
  --   vim.bo.expandtab = true     -- use spaces, not tabs
  --   vim.bo.shiftwidth = 4       -- indentation size
  --   vim.bo.tabstop = 4          -- number of spaces per tab
  --   vim.bo.softtabstop = 4
  -- end,
  -- })

  -- },
}

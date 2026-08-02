return {
  {
    'kristijanhusak/vim-dadbod-ui',

    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },

    keys = {
      { '<leader>du', '<cmd>DBUIToggle<cr>', desc = 'Toggle database UI' },
      { '<leader>df', '<cmd>DBUIFindBuffer<cr>', desc = 'Find database buffer' },
    },

    dependencies = {
      {
        'tpope/vim-dadbod',
        lazy = true,
      },
      {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql' },
        lazy = true,
      },
    },

    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_winwidth = 40

      vim.g.db_ui_table_helpers = {
        sqlite = {
          List = 'select * from "{table}" limit 100',
          Count = 'select count(*) as row_count from "{table}"',
        },
      }

      local group = vim.api.nvim_create_augroup('DadbodConfig', {
        clear = true,
      })

      local function get_drawer()
        local ok, drawer = pcall(vim.fn['db_ui#drawer#get'])

        if not ok or type(drawer) ~= 'table' then
          return nil
        end

        return drawer
      end

      local function execute_plug(mapping)
        local keys = vim.api.nvim_replace_termcodes(mapping, true, false, true)

        vim.api.nvim_feedkeys(keys, 'mx', false)
      end

      local function restore_dbui_width()
        local width = tonumber(vim.g.db_ui_winwidth) or 40

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(win) then
            local buf = vim.api.nvim_win_get_buf(win)

            if vim.bo[buf].filetype == 'dbui' then
              vim.wo[win].winfixwidth = true
              vim.api.nvim_win_set_width(win, width)
            end
          end
        end
      end

      local function quote_sqlite_identifier(identifier)
        return '"' .. tostring(identifier):gsub('"', '""') .. '"'
      end

      local function preview_table()
        local drawer = get_drawer()

        if not drawer then
          return
        end

        local line = vim.api.nvim_win_get_cursor(0)[1]
        local item = drawer.content and drawer.content[line]

        if not item then
          return
        end

        -- A real table row has a table name.
        -- Other nodes keep the normal DBUI `l` behavior.
        if not item.table or item.table == '' then
          execute_plug '<Plug>(DBUI_GotoChildNode)'
          return
        end

        local db = drawer.dbui and drawer.dbui.dbs and drawer.dbui.dbs[item.dbui_db_key_name]

        if not db then
          vim.notify('Dadbod UI: database connection not found', vim.log.levels.ERROR)
          return
        end

        local table_name = '"' .. tostring(item.table):gsub('"', '""') .. '"'

        local query = string.format('select * from %s limit 100;', table_name)

        local buf = vim.api.nvim_create_buf(false, true)

        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].bufhidden = 'wipe'
        vim.bo[buf].swapfile = false
        vim.bo[buf].filetype = db.filetype or 'sql'

        vim.b[buf].db = db.conn
        vim.b[buf].dbui_db_key_name = item.dbui_db_key_name
        vim.b[buf].dbui_table_name = item.table
        vim.b[buf].dadbod_preview_scratch = true

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { query })

        vim.api.nvim_buf_call(buf, function()
          vim.cmd '%DB'
        end)
      end

      -- Pressing `l` on a table executes the preview directly.
      --
      -- It does not expand the table or select the List helper.
      -- The SQL buffer is hidden and disposable.
      -- local function preview_table()
      --   local drawer = get_drawer()

      --   if not item then
      --     return
      --   end

      --   if not item.table or item.table == '' then
      --     execute_plug '<Plug>(DBUI_GotoChildNode)'
      --     return
      --   end

      --   if not drawer then
      --     return
      --   end

      --   local line = vim.api.nvim_win_get_cursor(0)[1]
      --   local item = drawer.content and drawer.content[line]

      --   -- Preserve normal DBUI `l` behavior outside table rows.
      --   if not item or item.type ~= 'table' then
      --     execute_plug '<Plug>(DBUI_GotoChildNode)'
      --     return
      --   end

      --   local db = drawer.dbui and drawer.dbui.dbs and drawer.dbui.dbs[item.dbui_db_key_name]

      --   if not db then
      --     vim.notify('Dadbod UI: database connection not found', vim.log.levels.ERROR)
      --     return
      --   end

      --   local table = quote_sqlite_identifier(item.table)

      --   local query = string.format('select * from %s limit 100;', table)

      --   local buf = vim.api.nvim_create_buf(false, true)

      --   vim.bo[buf].buftype = 'nofile'
      --   vim.bo[buf].bufhidden = 'wipe'
      --   vim.bo[buf].swapfile = false
      --   vim.bo[buf].filetype = db.filetype or 'sql'

      --   vim.b[buf].db = db.conn
      --   vim.b[buf].dbui_db_key_name = item.dbui_db_key_name
      --   vim.b[buf].dbui_table_name = item.table
      --   vim.b[buf].dadbod_preview_scratch = true

      --   vim.api.nvim_buf_set_lines(buf, 0, -1, false, { query })

      --   vim.api.nvim_buf_call(buf, function()
      --     vim.cmd '%DB'
      --   end)
      -- end

      -- Pressing `q` opens DBUI's New query item for the current database.
      -- It does not execute anything.
      local function open_new_query()
        local drawer_win = vim.api.nvim_get_current_win()
        local drawer = get_drawer()

        if not drawer then
          return
        end

        local line = vim.api.nvim_win_get_cursor(drawer_win)[1]
        local item = drawer.content and drawer.content[line]

        if not item then
          return
        end

        local db_key = item.dbui_db_key_name

        if not db_key then
          vim.notify('Dadbod UI: cursor is not inside a database', vim.log.levels.WARN)
          return
        end

        for index, candidate in ipairs(drawer.content or {}) do
          local same_database = candidate.dbui_db_key_name == db_key

          local is_new_query = candidate.type == 'query' or candidate.label == 'New query'

          if same_database and is_new_query then
            vim.api.nvim_win_set_cursor(drawer_win, { index, 0 })

            execute_plug '<Plug>(DBUI_SelectLine)'
            return
          end
        end

        vim.notify('Dadbod UI: New query item not found', vim.log.levels.WARN)
      end

      -- Put Dadbod output windows on the far right.
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = 'dbout',

        callback = function(event)
          vim.bo[event.buf].bufhidden = 'wipe'
          vim.bo[event.buf].swapfile = false

          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) then
              return
            end

            local result_win = vim.fn.bufwinid(event.buf)

            if result_win ~= -1 then
              vim.api.nvim_win_call(result_win, function()
                vim.cmd 'wincmd L'
              end)
            end

            restore_dbui_width()
            vim.schedule(restore_dbui_width)
          end)
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = 'dbui',

        callback = function(event)
          vim.wo.winfixwidth = true

          vim.keymap.set('n', 'l', preview_table, {
            buffer = event.buf,
            silent = true,
            desc = 'Preview table rows',
          })

          vim.keymap.set('n', 'q', open_new_query, {
            buffer = event.buf,
            silent = true,
            desc = 'Open new database query',
          })

          -- q now creates a query, so use Q to close DBUI.
          vim.keymap.set('n', 'Q', '<Plug>(DBUI_Quit)', {
            buffer = event.buf,
            silent = true,
            desc = 'Close database UI',
          })
        end,
      })
    end,
  },
}

-- return {
--   {
--     'kristijanhusak/vim-dadbod-ui',

--     cmd = {
--       'DBUI',
--       'DBUIToggle',
--       'DBUIAddConnection',
--       'DBUIFindBuffer',
--     },

--     keys = {
--       { '<leader>du', '<cmd>DBUIToggle<cr>', desc = 'Toggle database UI' },
--       { '<leader>df', '<cmd>DBUIFindBuffer<cr>', desc = 'Find database buffer' },
--     },

--     dependencies = {
--       {
--         'tpope/vim-dadbod',
--         lazy = true,
--       },
--       {
--         'kristijanhusak/vim-dadbod-completion',
--         ft = { 'sql', 'mysql', 'plsql' },
--         lazy = true,
--       },
--     },

--     init = function()
--       vim.g.db_ui_use_nerd_fonts = 1
--       vim.g.db_ui_execute_on_save = 0
--       vim.g.db_ui_auto_execute_table_helpers = 1
--       vim.g.db_ui_winwidth = 40

--       vim.g.db_ui_table_helpers = {
--         sqlite = {
--           List = 'select * from "{table}" limit 100',
--           Count = 'select count(*) as row_count from "{table}"',
--         },
--       }

--       local group = vim.api.nvim_create_augroup('DadbodConfig', {
--         clear = true,
--       })

--       -- Remember the most recently opened temporary table-helper query.
--       local last_helper_buf = nil

--       vim.api.nvim_create_autocmd('FileType', {
--         group = group,
--         pattern = { 'sql', 'mysql', 'plsql' },
--         callback = function(event)
--           vim.schedule(function()
--             if not vim.api.nvim_buf_is_valid(event.buf) then
--               return
--             end

--             local table_name = vim.b[event.buf].dbui_table_name

--             -- Only treat generated table-helper queries as disposable.
--             -- Normal "New query" and saved-query buffers are unaffected.
--             if table_name and table_name ~= '' then
--               last_helper_buf = event.buf
--               vim.bo[event.buf].bufhidden = 'wipe'
--               vim.bo[event.buf].swapfile = false
--             end
--           end)
--         end,
--       })

--       -- the drawer will resize without this
--       local function restore_dbui_width()
--         local width = tonumber(vim.g.db_ui_winwidth) or 40

--         for _, win in ipairs(vim.api.nvim_list_wins()) do
--           if vim.api.nvim_win_is_valid(win) then
--             local buf = vim.api.nvim_win_get_buf(win)

--             if vim.bo[buf].filetype == 'dbui' then
--               vim.wo[win].winfixwidth = true
--               vim.api.nvim_win_set_width(win, width)
--             end
--           end
--         end
--       end

--       local function feed_plug(mapping)
--         local keys = vim.api.nvim_replace_termcodes(mapping, true, false, true)
--         vim.api.nvim_feedkeys(keys, 'mx', false)
--       end

--       local function preview_table()
--         local drawer_win = vim.api.nvim_get_current_win()
--         -- local table_line = vim.fn.line '.'
--         local table_line = vim.api.nvim_win_get_cursor(drawer_win)[1]

--         local ok, drawer = pcall(vim.fn['db_ui#drawer#get'])
--         if not ok or type(drawer) ~= 'table' then
--           return
--         end

--         local item = drawer.content and drawer.content[table_line]

--         -- Preserve normal `l` behavior on non-table nodes.
--         if not item or item.type ~= 'table' then
--           feed_plug '<Plug>(DBUI_GotoChildNode)'
--           return
--         end

--         local table_level = item.level

--         local function collapse_table()
--           vim.schedule(function()
--             if not vim.api.nvim_win_is_valid(drawer_win) then
--               return
--             end

--             vim.api.nvim_win_call(drawer_win, function()
--               vim.api.nvim_win_set_cursor(drawer_win, { table_line, 0 })

--               local refreshed = vim.fn['db_ui#drawer#get']()
--               local table = refreshed.content and refreshed.content[table_line]

--               if table and table.expanded then
--                 feed_plug '<Plug>(DBUI_SelectLine)'
--               end
--             end)
--           end)
--         end

--         local function execute_list()
--           if not vim.api.nvim_win_is_valid(drawer_win) then
--             return
--           end

--           vim.api.nvim_win_call(drawer_win, function()
--             local refreshed = vim.fn['db_ui#drawer#get']()
--             local content = refreshed.content or {}

--             for index = table_line + 1, #content do
--               local child = content[index]

--               if child.level <= table_level then
--                 break
--               end

--               if child.label == 'List' then
--                 vim.api.nvim_win_set_cursor(drawer_win, { index, 0 })
--                 feed_plug '<Plug>(DBUI_SelectLine)'
--                 collapse_table()
--                 return
--               end
--             end

--             vim.notify('Dadbod UI: List helper not found', vim.log.levels.WARN)
--             collapse_table()
--           end)
--         end

--         if item.expanded then
--           execute_list()
--         else
--           -- Temporarily expand the table so Dadbod UI creates its helper nodes.
--           feed_plug '<Plug>(DBUI_SelectLine)'
--           vim.schedule(execute_list)
--         end
--       end

--       -- When results open:
--       --   1. move them to the far right
--       --   2. close the generated SELECT query window
--       --   3. wipe its temporary buffer
--       vim.api.nvim_create_autocmd('FileType', {
--         group = group,
--         pattern = 'dbout',

--         callback = function(event)
--           vim.bo[event.buf].bufhidden = 'wipe'
--           vim.bo[event.buf].swapfile = false

--           vim.schedule(function()
--             if not vim.api.nvim_buf_is_valid(event.buf) then
--               return
--             end

--             local result_win = vim.fn.bufwinid(event.buf)

--             -- Put the result at the far right.
--             if result_win ~= -1 then
--               vim.api.nvim_win_call(result_win, function()
--                 vim.cmd 'wincmd L'
--               end)
--             end

--             local helper_buf = last_helper_buf
--             last_helper_buf = nil

--             if helper_buf and vim.api.nvim_buf_is_valid(helper_buf) then
--               -- Close windows displaying the generated helper query.
--               for _, win in ipairs(vim.api.nvim_list_wins()) do
--                 if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == helper_buf then
--                   vim.api.nvim_win_close(win, true)
--                 end
--               end

--               -- Wipe the temporary query buffer.
--               if vim.api.nvim_buf_is_valid(helper_buf) then
--                 vim.api.nvim_buf_delete(helper_buf, { force = true })
--               end
--             end

--             -- Closing a split redistributes window sizes, so restore DBUI.
--             restore_dbui_width()

--             -- A second scheduled restore handles Neovim's final layout update.
--             vim.schedule(restore_dbui_width)
--           end)
--         end,
--       })

--       vim.api.nvim_create_autocmd('FileType', {
--         group = group,
--         pattern = 'dbui',
--         callback = function(event)
--           vim.keymap.set('n', 'l', preview_table, {
--             buffer = event.buf,
--             silent = true,
--             desc = 'Preview table without expanding it',
--           })
--         end,
--       })
--     end,
--   },
-- }

-- init = function()
--   vim.g.db_ui_use_nerd_fonts = 1
--   vim.g.db_ui_execute_on_save = 0

--   -- Selecting List, Count, etc. runs it immediately.
--   vim.g.db_ui_auto_execute_table_helpers = 1

--   vim.g.db_ui_table_helpers = {
--     sqlite = {
--       List = 'select * from "{table}" limit 100',
--       Count = 'select count(*) as row_count from "{table}"',
--     },
--   }

--   local group = vim.api.nvim_create_augroup('DadbodConfig', {
--     clear = true,
--   })

--   -- Table-helper query buffers are temporary previews.
--   --
--   -- Once the query buffer becomes hidden, wipe it instead of leaving
--   -- account-List-2026-... entries under DBUI's Buffers section.
--   vim.api.nvim_create_autocmd('FileType', {
--     group = group,
--     pattern = { 'sql', 'mysql', 'plsql' },
--     callback = function(event)
--       vim.schedule(function()
--         if not vim.api.nvim_buf_is_valid(event.buf) then
--           return
--         end

--         local table_name = vim.b[event.buf].dbui_table_name

--         if table_name and table_name ~= '' then
--           vim.bo[event.buf].bufhidden = 'wipe'
--           vim.bo[event.buf].swapfile = false
--         end
--       end)
--     end,
--   })

--   -- Put query results in a vertical window on the far right.
--   vim.api.nvim_create_autocmd('FileType', {
--     group = group,
--     pattern = 'dbout',
--     callback = function(event)
--       vim.bo[event.buf].bufhidden = 'wipe'
--       vim.bo[event.buf].swapfile = false

--       vim.schedule(function()
--         if not vim.api.nvim_buf_is_valid(event.buf) then
--           return
--         end

--         local win = vim.fn.bufwinid(event.buf)
--         if win == -1 then
--           return
--         end

--         vim.api.nvim_win_call(win, function()
--           vim.cmd 'wincmd L'
--         end)
--       end)
--     end,
--   })

--   -- Optional completion setup for manually written SQL queries.
--   vim.api.nvim_create_autocmd('FileType', {
--     group = group,
--     pattern = { 'sql', 'mysql', 'plsql' },
--     callback = function()
--       vim.opt_local.omnifunc = 'vim_dadbod_completion#omni'
--     end,
--   })
-- end,
-- return {

--   -- -- Database
--   { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
--   -- { 'tpope/vim-dadbod', lazy = true },
--   { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },

--   {
--     'kristijanhusak/vim-dadbod-ui',

--     cmd = {
--       'DBUI',
--       'DBUIToggle',
--       'DBUIAddConnection',
--       'DBUIFindBuffer',
--     },

--     dependencies = {
--       { 'tpope/vim-dadbod', lazy = true },
--       {
--         'kristijanhusak/vim-dadbod-completion',
--         ft = { 'sql', 'mysql', 'plsql' },
--         lazy = true,
--       },
--     },

--     init = function()
--       vim.g.db_ui_use_nerd_fonts = 1
--       vim.g.db_ui_execute_on_save = 0
--       vim.g.db_ui_auto_execute_table_helpers = 1

--       vim.g.db_ui_table_helpers = {
--         sqlite = {
--           List = 'select * from "{table}" limit 100',
--           Count = 'select count(*) as row_count from "{table}"',
--         },
--       }
--     end,
--   },
-- }
-- vim.api.nvim_create_autocmd('FileType', {
--   group = group,
--   pattern = 'dbout',
--   callback = function(event)
--     vim.bo[event.buf].bufhidden = 'wipe'
--     vim.bo[event.buf].swapfile = false

--     vim.schedule(function()
--       if not vim.api.nvim_buf_is_valid(event.buf) then
--         return
--       end

--       -- Move the result window to the far right.
--       local result_win = vim.fn.bufwinid(event.buf)

--       if result_win ~= -1 then
--         vim.api.nvim_win_call(result_win, function()
--           vim.cmd 'wincmd L'
--         end)
--       end

--       local helper_buf = last_helper_buf
--       last_helper_buf = nil

--       if not helper_buf or not vim.api.nvim_buf_is_valid(helper_buf) then
--         return
--       end

--       -- Close any window still displaying the generated query.
--       for _, win in ipairs(vim.api.nvim_list_wins()) do
--         if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == helper_buf then
--           vim.api.nvim_win_close(win, true)
--         end
--       end

--       -- Remove it from Neovim and DBUI's Buffers section.
--       if vim.api.nvim_buf_is_valid(helper_buf) then
--         vim.api.nvim_buf_delete(helper_buf, { force = true })
--       end
--     end)
--   end,
-- })

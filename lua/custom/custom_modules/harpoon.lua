local M = {}

function M.test_print()
  print 'Hello from harpoon module test_print!'
end

-- Telescope Harpoon extension definition
M.setup_telescope_harpoon = function()
  M.get_my_list()

  -- local telescope = require 'telescope'
  -- local pickers = require 'telescope.pickers'
  -- local finders = require 'telescope.finders'
  -- local sorters = require 'telescope.sorters'
  -- local actions = require 'telescope.actions'
  -- local action_state = require 'telescope.actions.state'
  -- local harpoon_ui = require 'harpoon.ui'
  -- local harpoon = require 'harpoon'
  --
  -- telescope.register_extension {
  --   exports = {
  --     harpoon = function(opts)
  --       opts = opts or {}
  --       local marks = harpoon.get_mark_config().marks or {}
  --
  --       local entries = {}
  --       for idx, mark in ipairs(marks) do
  --         table.insert(entries, {
  --           filename = mark.filename,
  --           display = string.format('%d: %s', idx, mark.filename),
  --           ordinal = mark.filename,
  --           index = idx,
  --         })
  --       end
  --
  --       pickers
  --         .new(opts, {
  --           prompt_title = 'Harpoon Marks',
  --           finder = finders.new_table {
  --             results = entries,
  --             entry_maker = function(entry)
  --               return {
  --                 value = entry.filename,
  --                 display = entry.display,
  --                 ordinal = entry.ordinal,
  --                 index = entry.index,
  --               }
  --             end,
  --           },
  --
  --           sorter = sorters.get_fuzzy_file(),
  --           attach_mappings = function(prompt_bufnr, map)
  --             actions.select_default:replace(function()
  --               local selection = action_state.get_selected_entry()
  --               if selection then
  --                 harpoon_ui.nav_file(selection.index)
  --               end
  --               actions.close(prompt_bufnr)
  --             end)
  --             return true
  --           end,
  --         })
  --         :find()
  --     end,
  --   },
  -- }
end

-- -- Load the extension during Harpoon setup
-- M.setup = function()
--   M.setup_telescope_harpoon()
--   require('telescope').load_extension('harpoon')
-- end

function M.get_my_list()
  local harpoon = require 'harpoon'
  local marks = harpoon.get_mark_config().marks -- Access `marks` directly from the returned table.
  local entries = {}

  for idx, mark in ipairs(marks) do
    table.insert(entries, {
      display = string.format('%d: %s', idx, mark.filename),
    })
  end

  -- for idx, mark in ipairs(marks) do
  --   table.insert(entries, {
  --     value = mark.filename,
  --     ordinal = mark.filename,
  --     display = string.format('%d: %s', idx, mark.filename),
  --     path = mark.filename,
  --     index = idx,
  --   })
  -- end

  -- for _, item in ipairs(marks.items) do
  --   table.insert(entries, item.value)
  -- end

  -- Helper function to print tables
  local function table_to_string(tbl, indent)
    indent = indent or 0
    local to_string = ''
    local indent_str = string.rep('  ', indent)
    for key, value in pairs(tbl) do
      if type(value) == 'table' then
        to_string = to_string .. indent_str .. key .. ':\n' .. table_to_string(value, indent + 1)
      else
        to_string = to_string .. indent_str .. key .. ': ' .. tostring(value) .. '\n'
      end
    end
    return to_string
  end

  print 'The list is:'
  print(table_to_string(entries))
end

-- function M.get_my_list()
--   local harpoon = require 'harpoon'
--   -- local harpoon_mark = require 'harpoon.mark'
--   -- local harpoon_ui = require 'harpoon.ui'
--   -- local harpoon_telescope = {}
--
--   local marks = harpoon.get_mark_config()
--
--   -- {
--   -- marks = { {
--   -- col = 0,
--   -- filename = "plugins/init.lua",
--   -- row = 179
--   -- }, {
--   -- col = 1,
--   -- filename = "custom_modules/harpoon.lua",
--   -- row = 27
--   -- }, {
--   -- col = 0,
--   -- filename = "plugins/telescope.lua",
--   -- row = 521
--   -- } }
--   -- }
--   local entries = {}
--
--   for idx, mark in ipairs(marks) do
--     table.insert(entries, {
--       value = mark.filename,
--       ordinal = mark.filename,
--       display = string.format('%d: %s', idx, mark.filename),
--       path = mark.filename,
--       index = idx,
--     })
--   end
--
--   -- Helper function to print tables
--   local function table_to_string(tbl, indent)
--     indent = indent or 0
--     local to_string = ''
--     local indent_str = string.rep('  ', indent)
--     for key, value in pairs(tbl) do
--       if type(value) == 'table' then
--         to_string = to_string .. indent_str .. key .. ':\n' .. table_to_string(value, indent + 1)
--       else
--         to_string = to_string .. indent_str .. key .. ': ' .. tostring(value) .. '\n'
--       end
--     end
--     return to_string
--   end
--
--   print 'The list is:'
--   print(table_to_string(entries))
-- end

-- {
--   add_file = <function 1>,
--   clear_all = <function 2>,
--   get_current_index = <function 3>,
--   get_index_of = <function 4>,
--   get_length = <function 5>,
--   get_marked_file = <function 6>,
--   get_marked_file_name = <function 7>,
--   on = <function 8>,
--   remove_empty_tail = <function 9>,
--   rm_file = <function 10>,
--   set_current_at = <function 11>,
--   set_mark_list = <function 12>,
--   status = <function 13>,
--   store_offset = <function 14>,
--   to_quickfix_list = <function 15>,
--   toggle_file = <function 16>,
--   valid_index = <function 17>
-- }

-- ui
-- {
--   close_notification = <function 1>,
--   location_window = <function 2>,
--   nav_file = <function 3>,
--   nav_next = <function 4>,
--   nav_prev = <function 5>,
--   notification = <function 6>,
--   on_menu_save = <function 7>,
--   select_menu_item = <function 8>,
--   toggle_quick_menu = <function 9>
-- }

function M.toggle_telescope()
  local harpoon = require 'harpoon'
  local harpoon_ui = require 'harpoon.ui'
  local marks = harpoon.get_mark_config().marks -- Access `marks` directly from the returned table.
  local entries = {}

  for idx, mark in ipairs(marks) do
    table.insert(entries, {
      display = string.format('%d: %s', idx, mark.filename),
      filename = mark.filename,
      ordinal = mark.filename,
      index = idx,
    })
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table {
        results = entries,
        entry_maker = function(entry)
          return {
            value = entry.filename,
            display = entry.display,
            ordinal = entry.ordinal,
            index = entry.index,
          }
        end,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local actions = require 'telescope.actions'
        local action_state = require 'telescope.actions.state'

        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection then
            harpoon_ui.nav_file(selection.index)
          end
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

function M.setup()
  local harpoon = require 'harpoon'
  local harpoon_mark = require 'harpoon.mark'
  local harpoon_ui = require 'harpoon.ui'
  local conf = require('telescope.config').values
  local telescope = require 'telescope'
  -- local actions = require 'telescope.actions'
  -- local action_state = require 'telescope.actions.state'

  -- REQUIRED
  harpoon.setup {}

  -- REQUIRED
  --
  -- harpoon:setup({
  --     -- Setting up custom behavior for a list named "cmd"
  --     "cmd" = {
  --
  --         -- When you call list:add() this function is called and the return
  --         -- value will be put in the list at the end.
  --         --
  --         -- which means same behavior for prepend except where in the list the
  --         -- return value is added
  --         --
  --         -- @param possible_value string only passed in when you alter the ui manual
  --         add = function(possible_value)
  --             -- get the current line idx
  --             local idx = vim.fn.line(".")
  --
  --             -- read the current line
  --             local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
  --             if cmd == nil then
  --                 return nil
  --             end
  --
  --             return {
  --                 value = cmd,
  --                 -- context = { ... any data you want ... },
  --             }
  --         end,
  --
  --         --- This function gets invoked with the options being passed in from
  --         --- list:select(index, <...options...>)
  --         --- @param list_item {value: any, context: any}
  --         --- @param list { ... }
  --         --- @param option any
  --         select = function(list_item, list, option)
  --             -- WOAH, IS THIS HTMX LEVEL XSS ATTACK??
  --             vim.cmd(list_item.value)
  --         end
  --
  --     }
  -- })

  -- Key mappings for Harpoon
  vim.keymap.set('n', '<leader>A', function()
    harpoon_mark.add_file() --this works
    -- my_list:add()
  end, { desc = 'Add file to Harpoon' })

  vim.keymap.set('n', '<leader>a', function()
    harpoon_ui.toggle_quick_menu()
  end, { desc = 'Toggle Harpoon quick menu' })

  vim.keymap.set('n', '<leader>Sp', M.toggle_telescope, { desc = 'Open Harpoon window' })

  for i = 1, 5 do
    vim.keymap.set('n', string.format('<leader>%d', i), function()
      require('harpoon.ui').nav_file(i)
    end, { desc = string.format('Navigate to Harpoon file %d', i) })
  end

  vim.keymap.set('n', '<leader>Sm', function()
    M.get_my_list()
  end, { desc = 'Harpoon test print list' })

  -- Telescope integration
  local function toggle_telescope()
    local marks = harpoon_mark.get_all()
    local entries = {}

    for idx, mark in ipairs(marks) do
      table.insert(entries, {
        value = mark.filename,
        ordinal = mark.filename,
        display = string.format('%d: %s', idx, mark.filename),
        path = mark.filename,
        index = idx,
      })
    end

    require('telescope.pickers')
      .new({}, {
        prompt_title = 'Harpoon Marks',
        finder = require('telescope.finders').new_table {
          results = entries,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.display,
              ordinal = entry.ordinal,
              path = entry.path,
              index = entry.index,
            }
          end,
        },
        sorter = require('telescope.config').values.generic_sorter {},

        attach_mappings = function(_, map)
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'

          map('i', '<CR>', function(bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(bufnr)
            require('harpoon.ui').nav_file(selection.value.index)
          end)

          map('n', '<CR>', function(bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(bufnr)
            require('harpoon.ui').nav_file(selection.value.index)
          end)

          return true
        end,
      })
      :find()
  end

  -- attach_mappings = function(_, map)
  --   map('i', '<CR>', function(bufnr)
  --     local selection = require('telescope.actions.state').get_selected_entry(bufnr)
  --     require('telescope.actions').close(bufnr)
  --     harpoon_ui.nav_file(selection.value.index)
  --   end)
  --   map('n', '<CR>', function(bufnr)
  --     local selection = require('telescope.actions.state').get_selected_entry(bufnr)
  --     require('telescope.actions').close(bufnr)
  --     harpoon_ui.nav_file(selection.value.index)
  --   end)
  --   return true
  -- end,

  -- sorter = conf.generic_sorter({}),
  -- attach_mappings = function(_, map)
  --   map('i', '<CR>', function()
  --     local selection = action_state.get_selected_entry()
  --     actions.close()
  --     require('harpoon.ui').nav_file(selection.value.index)
  --   end)
  --   map('n', '<CR>', function()
  --     local selection = action_state.get_selected_entry()
  --     actions.close()
  --     require('harpoon.ui').nav_file(selection.value.index)
  --   end)
  --   return true
  -- end,
  -- })
  -- :find()

  -- vim.keymap.set('n', '<leader>i', toggle_telescope, { desc = 'Open Harpoon Telescope Picker [i]' })

  -- basic telescope configuration
  -- local conf = require("telescope.config").values
  -- local function toggle_telescope3()
  --   -- local file_paths = {}
  --   print 'Hello from harpoon telescope!'
  --   local harpoon_files = {}

  --   harpoon_files.marks = function()
  --     local marks = harpoon_mark.get_all()
  --     local entries = {}

  --     for idx, mark in ipairs(marks) do
  --       table.insert(entries, {
  --         value = mark.filename,
  --         ordinal = mark.filename,
  --         display = string.format('%d: %s', idx, mark.filename),
  --         path = mark.filename,
  --         index = idx,
  --       })
  --     end

  --     for _, item in ipairs(harpoon_files.items) do
  --       table.insert(harpoon_files, item.value)
  --     end

  --     require('telescope.pickers')
  --       .new({}, {
  --         prompt_title = 'Harpoon',
  --         finder = require('telescope.finders').new_table {
  --           results = harpoon_files,
  --         },
  --         previewer = conf.file_previewer {},
  --         sorter = conf.generic_sorter {},
  --       })
  --       :find()
  --   end

  --   -- Optional: Print a message to confirm the setup was called
  --   print 'Hello from harpoon module setup!'
  -- end

  -- vim.keymap.set('n', '<leader>Sa', function()
  --   toggle_telescope3()
  -- end, { desc = 'Open harpoon window' })

  -- local function toggle_telescope4()
  --   print 'Hello from harpoon telescope!'

  -- basic telescope configuration
  -- local conf = require("telescope.config").values
  local function toggle_telescope4(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(file_paths, item.value)
    end

    require('telescope.pickers')
      .new({}, {
        prompt_title = 'Harpoon',
        finder = require('telescope.finders').new_table {
          results = file_paths,
        },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
      })
      :find()
  end

  --
  --
  --
  --   -- Try to get all marked files
  --   local marks = harpoon_mark.get_all and harpoon_mark.get_all() or harpoon_mark.get_marked_files()
  --   local file_paths = {}
  --
  --   -- Populate file_paths with Harpoon mark filenames
  --   for idx, mark in ipairs(marks) do
  --     table.insert(file_paths, {
  --       value = mark.filename,
  --       ordinal = mark.filename,
  --       display = string.format('%d: %s', idx, mark.filename),
  --       path = mark.filename,
  --       index = idx,
  --     })
  --   end
  --
  --   -- Print the file paths for debugging
  --   print 'Harpoon Files:'
  --   for _, file in ipairs(file_paths) do
  --     print(file.display)
  --   end
  --
  --   -- Display the Telescope picker
  --   require('telescope.pickers')
  --     .new({}, {
  --       prompt_title = 'Harpoon Files',
  --       finder = require('telescope.finders').new_table {
  --         results = file_paths,
  --         entry_maker = function(entry)
  --           return {
  --             value = entry.path,
  --             display = entry.display,
  --             ordinal = entry.ordinal,
  --             index = entry.index,
  --           }
  --         end,
  --       },
  --
  --       previewer = conf.file_previewer {},
  --       sorter = conf.generic_sorter {},
  --       attach_mappings = function(_, map)
  --         local actions = require 'telescope.actions'
  --         local action_state = require 'telescope.actions.state'
  --
  --         map('i', '<CR>', function(bufnr)
  --           local selection = action_state.get_selected_entry()
  --           actions.close(bufnr)
  --           require('harpoon.ui').nav_file(selection.index)
  --         end)
  --
  --         map('n', '<CR>', function(bufnr)
  --           local selection = action_state.get_selected_entry()
  --           actions.close(bufnr)
  --           require('harpoon.ui').nav_file(selection.index)
  --         end)
  --
  --         -- previewer = conf.file_previewer({}),
  --         -- sorter = conf.generic_sorter({}),
  --         -- attach_mappings = function(_, map)
  --         --   local actions = require('telescope.actions')
  --         --   local action_state = require('telescope.actions.state')
  --         --
  --         --   map('i', '<CR>', function()
  --         --     local selection = action_state.get_selected_entry()
  --         --     actions.close()
  --         --     require('harpoon.ui').nav_file(selection.index)
  --         --   end)
  --         --
  --         --   map('n', '<CR>', function()
  --         --     local selection = action_state.get_selected_entry()
  --         --     actions.close()
  --         --     require('harpoon.ui').nav_file(selection.index)
  --         --   end)
  --         --
  --         return true
  --       end,
  --     })
  --     :find()
  -- end
  --
  -- --   -- Get all Harpoon marks
  -- --   local marks = harpoon_mark.get_all()
  -- --   local file_paths = {}
  -- --
  -- --   -- Populate file_paths with Harpoon mark filenames
  -- --   for idx, mark in ipairs(marks) do
  -- --     table.insert(file_paths, {
  -- --       value = mark.filename,
  -- --       ordinal = mark.filename,
  -- --       display = string.format('%d: %s', idx, mark.filename),
  -- --       path = mark.filename,
  -- --       index = idx,
  -- --     })
  -- --   end
  -- --
  -- --   -- Print the file paths for debugging
  -- --   print 'Harpoon Files:'
  -- --   for _, file in ipairs(file_paths) do
  -- --     print(file.display)
  -- --   end
  -- --
  -- --   -- Display the Telescope picker
  -- --   require('telescope.pickers')
  -- --     .new({}, {
  -- --       prompt_title = 'Harpoon Files',
  -- --       finder = require('telescope.finders').new_table {
  -- --         results = file_paths,
  -- --         entry_maker = function(entry)
  -- --           return {
  -- --             value = entry.path,
  -- --             display = entry.display,
  -- --             ordinal = entry.ordinal,
  -- --             index = entry.index,
  -- --           }
  -- --         end,
  -- --       },
  -- --       previewer = conf.file_previewer {},
  -- --       sorter = conf.generic_sorter {},
  -- --       attach_mappings = function(_, map)
  -- --         local actions = require 'telescope.actions'
  -- --         local action_state = require 'telescope.actions.state'
  -- --
  -- --         map('i', '<CR>', function(bufnr)
  -- --           local selection = action_state.get_selected_entry()
  -- --           actions.close(bufnr)
  -- --           require('harpoon.ui').nav_file(selection.index)
  -- --         end)
  -- --
  -- --         map('n', '<CR>', function(bufnr)
  -- --           local selection = action_state.get_selected_entry()
  -- --           actions.close(bufnr)
  -- --           require('harpoon.ui').nav_file(selection.index)
  -- --         end)
  -- --
  -- --         return true
  -- --       end,
  -- --     })
  -- --     :find()
  -- -- end
  --
  -- Key mapping for the Telescope picker
  vim.keymap.set('n', '<leader>Sa', function()
    toggle_telescope4(harpoon:list())
  end, { desc = 'Open Harpoon Telescope Picker' })
end

return M

--         require('telescope.pickers').new({}, {
--           prompt_title = 'Harpoon Marks',
--           finder = require('telescope.finders').new_table {
--             results = entries,
--             entry_maker = function(entry)
--               return {
--                 value = entry,
--                 display = entry.display,
--                 ordinal = entry.ordinal,
--                 path = entry.path,
--                 index = entry.index,
--               }
--             end,
--           },
--           sorter = require('telescope.config').values.generic_sorter({}),
--           attach_mappings = function(_, map)
--             map('i', '<CR>', function(bufnr)
--               local selection = require('telescope.actions.state').get_selected_entry(bufnr)
--               require('telescope.actions').close(bufnr)
--               harpoon_ui.nav_file(selection.value.index)
--             end)
--             map('n', '<CR>', function(bufnr)
--               local selection = require('telescope.actions.state').get_selected_entry(bufnr)
--               require('telescope.actions').close(bufnr)
--               harpoon_ui.nav_file(selection.value.index)
--             end)
--             return true
--           end,
--         }):find()
--       end

--       return harpoon_telescope
--     end,

-- Telescope integration
--   local function toggle_telescope2()
--     -- local marks = harpoon_mark.get_all()
--     -- local entries = {}
--
--   -- local harpoon_mark = require 'harpoon.mark'
--   -- local harpoon_ui = require 'harpoon.ui'
--   local harpoon_telescope = {}
--
--   harpoon_telescope.marks = function()
--     local marks = harpoon_mark.get_all()
--     local entries = {}
--
--     for idx, mark in ipairs(marks) do
--       table.insert(entries, {
--         value = mark.filename,
--         ordinal = mark.filename,
--         display = string.format('%d: %s', idx, mark.filename),
--         path = mark.filename,
--         index = idx,
--       })
--     end
--
--     require('telescope.pickers')
--       .new({}, {
--         prompt_title = 'Harpoon Marks',
--         finder = require('telescope.finders').new_table {
--           results = entries,
--           entry_maker = function(entry)
--             return {
--               value = entry,
--               display = entry.display,
--               ordinal = entry.ordinal,
--               path = entry.path,
--               index = entry.index,
--             }
--           end,
--         },
--         sorter = require('telescope.config').values.generic_sorter {},
--         attach_mappings = function(_, map)
--           local actions = require 'telescope.actions'
--           local action_state = require 'telescope.actions.state'
--
--           map('i', '<CR>', function()
--             local selection = action_state.get_selected_entry()
--             actions.close()
--             require('harpoon.ui').nav_file(selection.value.index)
--           end)
--
--           map('n', '<CR>', function()
--             local selection = action_state.get_selected_entry()
--             actions.close()
--             require('harpoon.ui').nav_file(selection.value.index)
--           end)
--
--           return true
--         end,
--
--         -- attach_mappings = function(_, map)
--         --   map('i', '<CR>', function(bufnr)
--         --     local selection = require('telescope.actions.state').get_selected_entry(bufnr)
--         --     require('telescope.actions').close(bufnr)
--         --     harpoon_ui.nav_file(selection.value.index)
--         --   end)
--         --   map('n', '<CR>', function(bufnr)
--         --     local selection = require('telescope.actions.state').get_selected_entry(bufnr)
--         --     require('telescope.actions').close(bufnr)
--         --     harpoon_ui.nav_file(selection.value.index)
--         --   end)
--         --   return true
--         -- end,
--       })
--       :find()
--   end
--
--   vim.keymap.set('n', '<leader>tH', function()
--     require('telescope').extensions.harpoon.marks()
--   end, { desc = '[T]elescope [H]arpoon Marks' })
--
--   return harpoon_telescope
-- end
--

--   vim.keymap.set('n', '<leader>i', toggle_telescope, { desc = 'Open Harpoon Telescope Picker [i]' })

-- Optional: Print a message to confirm the setup was called

-- local M = {}

-- function M.test_print()
--   print 'Hello from harpoon module test_print!'
-- end

-- function M.setup()
--   local harpoon = require 'harpoon'
--   local harpoon_mark = require 'harpoon.mark'
--   local harpoon_ui = require 'harpoon.ui'

--   -- REQUIRED
--   harpoon.setup()
--   -- REQUIRED

--   -- Key mappings
--   vim.keymap.set('n', '<leader>A', function()
--     harpoon_mark.add_file()
--   end, { desc = 'Add file to Harpoon' })

--   vim.keymap.set('n', '<leader>a', function()
--     harpoon_ui.toggle_quick_menu()
--   end, { desc = 'Toggle Harpoon quick menu' })

--   for i = 1, 5 do
--     vim.keymap.set('n', string.format('<leader>%d', i), function()
--       require('harpoon.ui').nav_file(i)
--     end, { desc = string.format('Navigate to Harpoon file %d', i) })
--   end

--   -- basic telescope configuration
--   local conf = require('telescope.config').values
--   local function toggle_telescope(harpoon_files)
--     local file_paths = {}
--     for _, item in ipairs(harpoon_files.items) do
--       table.insert(file_paths, item.value)
--     end

--     require('telescope.pickers')
--       .new({}, {
--         prompt_title = 'Harpoon',
--         finder = require('telescope.finders').new_table {
--           results = file_paths,
--         },
--         previewer = conf.file_previewer {},
--         sorter = conf.generic_sorter {},
--       })
--       :find()
--   end

--   vim.keymap.set('n', '<leader>i', function()
--     toggle_telescope(harpoon:list())
--   end, { desc = 'Open harpoon window test [i]' })

--   -- Optional: Print a message to confirm the setup was called
--   print 'Hello from harpoon module setup!'
-- end

-- return M

-- return {}
-- local M = {}
-- local harpoon = require 'harpoon'

-- function M.test_print()
--   print 'Hello from harpoon module test_print!'
-- end

-- function M.setup()
--   -- -- REQUIRED
--   harpoon:setup()
--   -- REQUIRED

--   -- vim.keymap.set('n', '<leader>a', function()
--   --   harpoon:list():add()
--   -- end)
--   -- vim.keymap.set('n', '<C-e>', function()
--   --   harpoon.ui:toggle_quick_menu(harpoon:list())
--   -- end)

--   vim.keymap.set('n', '<leader>A', function()
--     harpoon:list():add()
--     -- harpoon.mark:add_file()
--     -- require('harpoon.mark').add_file()
--   end, { desc = 'Add file to Harpoon' })

--   vim.keymap.set('n', '<leader>a', function()
--     harpoon.ui:toggle_quick_menu(harpoon:list())
--     -- harpoon.ui.toggle_quick_menu()
--     -- require('harpoon.ui').toggle_quick_menu()
--   end, { desc = 'Toggle Harpoon quick menu' })

--   print 'Hello from harpoon module setup!'
-- end
-- return M

-- vim.keymap.set('n', '<C-h>', function()
--   harpoon:list():select(1)
-- end)
-- vim.keymap.set('n', '<C-t>', function()
--   harpoon:list():select(2)
-- end)
-- vim.keymap.set('n', '<C-n>', function()
--   harpoon:list():select(3)
-- end)
-- vim.keymap.set('n', '<C-s>', function()
--   harpoon:list():select(4)
-- end)

-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set('n', '<C-S-P>', function()
--   harpoon:list():prev()
-- end)
-- vim.keymap.set('n', '<C-S-N>', function()
--   harpoon:list():next()
-- end)

-- vim.keymap.set('n', '<leader>A', function()
--   require('harpoon.mark').add_file()
-- end, { desc = 'Add file to Harpoon' })
--
-- vim.keymap.set('n', '<leader>a', function()
--   require('harpoon.ui').toggle_quick_menu()
-- end, { desc = 'Toggle Harpoon quick menu' })
--
-- vim.keymap.set('n', '<leader>i', function()
--   harpoon.ui:toggle_quick_menu(harpoon:list())
-- end, { desc = 'Toggle Harpoon quick menu test' })

-- Initialize Harpoon
-- local harpoon = require('harpoon').setup()
-- harpoon:setup()

--
--   -- Keybindings
--   local keymap = vim.keymap.set
--   -- local opts = { noremap = true, silent = true }
--   -- keymap('n', '<leader>A', function()
--   --   require('harpoon.mark').add_file()
--   -- end, vim.tbl_extend('force', opts, { desc = 'Add file to Harpoon' }))
--

--   for i = 1, 5 do
--     keymap('n', string.format('<leader>%d', i), function()
--       require('harpoon.ui').nav_file(i)
--     end, { desc = string.format('Navigate to Harpoon file %d', i) })
--   end

--ones that worked
-- keys = {
--    {
--      '<leader>A',
--      function()
--        require('harpoon.mark').add_file()
--      end,
--      desc = 'Add file to Harpoon',
--    },
--    {
--      '<leader>a',
--      function()
--        require('harpoon.ui').toggle_quick_menu()
--      end,
--      desc = 'Toggle Harpoon quick menu',
--    },
--    {
--      '<leader>1',
--      function()
--        require('harpoon.ui').nav_file(1)
--      end,
--      desc = 'Navigate to Harpoon file 1',
--    },
--    {
--      '<leader>2',
--      function()
--        require('harpoon.ui').nav_file(2)
--      end,
--      desc = 'Navigate to Harpoon file 2',
--    },
--    {
--      '<leader>3',
--      function()
--        require('harpoon.ui').nav_file(3)
--      end,
--      desc = 'Navigate to Harpoon file 3',
--    },
--    {
--      '<leader>4',
--      function()
--        require('harpoon.ui').nav_file(4)
--      end,
--      desc = 'Navigate to Harpoon file 4',
--    },
--    {
--      '<leader>5',
--      function()
--        require('harpoon.ui').nav_file(5)
--      end,
--      desc = 'Navigate to Harpoon file 5',
--    },
--  },

-- return M

-- local harpoon = require 'harpoon'
-- M = {}
--
-- M.setup = function()
--   -- REQUIRED
--   harpoon:setup()
--   -- REQUIRED
--
--   -- vim.keymap.set('n', '[D', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
--
--   -- vim.keymap.set("n", "<leader>A", function() harpoon:list():append() end)
--   vim.keymap.set('n', '<leader>A', function()
--     harpoon:list():append()
--   end, { desc = 'Harpoon Add' })
--
--   vim.keymap.set('n', '<leader>a', function()
--     harpoon.ui:toggle_quick_menu(harpoon:list())
--   end, { desc = 'Harpoon quick menu' })
--
--   vim.keymap.set('n', '<leader>1', function()
--     harpoon:list():select(1)
--   end, { desc = 'Nav to Harpoon 1' })
--
--   vim.keymap.set('n', '<leader>2', function()
--     harpoon:list():select(2)
--   end, { desc = 'Nav to Harpoon 2' })
--
--   vim.keymap.set('n', '<leader>3', function()
--     harpoon:list():select(3)
--   end, { desc = 'Nav to Harpoon 3' })
--   -- these are cnext/cprev
--   -- vim.keymap.set("n", "<F4>", function() harpoon:list():select(4) end)
--   -- vim.keymap.set("n", "<F5>", function() harpoon:list():select(5) end)
--   -- vim.keymap.set("n", "<F6>", function() harpoon:list():select(6) end)
--
--   -- Toggle previous & next buffers stored within Harpoon list
--   -- vim.keymap.set("n", "<F7>", function() harpoon:list():prev() end)
--   -- vim.keymap.set("n", "<F8>", function() harpoon:list():next() end)
--
--   -- basic telescope configuration
--   local conf = require('telescope.config').values
--   local function toggle_telescope(harpoon_files)
--     local file_paths = {}
--     for _, item in ipairs(harpoon_files.items) do
--       table.insert(file_paths, item.value)
--     end
--
--     require('telescope.pickers')
--       .new({}, {
--         prompt_title = 'Harpoon',
--         finder = require('telescope.finders').new_table {
--           results = file_paths,
--         },
--         previewer = conf.file_previewer {},
--         sorter = conf.generic_sorter {},
--       })
--       :find()
--   end
--
--   -- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
--   vim.keymap.set('n', '<leader>Sh', function()
--     toggle_telescope(harpoon:list())
--   end, { desc = 'Open harpoon window' })
-- end
--
-- return M

-- return {}
--   'ThePrimeagen/harpoon',
--   lazy = false,
--   branch = 'harpoon2',
--   init = function()
--     local harpoon = require 'harpoon'
--
--     -- REQUIRED
--     harpoon:setup()
--     -- REQUIRED
--
--     vim.keymap.set('n', '<leader>a', function()
--       harpoon:list():append()
--     end)
--     vim.keymap.set('n', '<C-e>', function()
--       harpoon.ui:toggle_quick_menu(harpoon:list())
--     end)
--
--     vim.keymap.set('n', '<C-h>', function()
--       harpoon:list():select(1)
--     end)
--     vim.keymap.set('n', '<C-t>', function()
--       harpoon:list():select(2)
--     end)
--     vim.keymap.set('n', '<C-n>', function()
--       harpoon:list():select(3)
--     end)
--     vim.keymap.set('n', '<C-s>', function()
--       harpoon:list():select(4)
--     end)
--
--     -- Toggle previous & next buffers stored within Harpoon list
--     vim.keymap.set('n', '<C-S-P>', function()
--       harpoon:list():prev()
--     end)
--     vim.keymap.set('n', '<C-S-N>', function()
--       harpoon:list():next()
--     end)
--   end,
--   dependencies = { 'nvim-lua/plenary.nvim' },
-- }

-- local M = {}
--
-- function M.setup()
--   local harpoon = require 'harpoon'
--   harpoon:setup()
--
--   vim.keymap.set('n', '<leader>a', function()
--     harpoon:list():add()
--   end)
--
--   vim.keymap.set('n', '<C-e>', function()
--     harpoon.ui:toggle_quick_menu(harpoon:list())
--   end)
--
--   vim.keymap.set('n', '<C-h>', function()
--     harpoon:list():select(1)
--   end)
--
--   vim.keymap.set('n', '<C-t>', function()
--     harpoon:list():select(2)
--   end)
--
--   vim.keymap.set('n', '<C-n>', function()
--     harpoon:list():select(3)
--   end)
--
--   vim.keymap.set('n', '<C-s>', function()
--     harpoon:list():select(4)
--   end)
--
--   -- Toggle previous & next buffers stored within Harpoon list
--   -- vim.keymap.set('n', '<C-S-P>', function()
--   vim.keymap.set('n', '<C-S-P>', function()
--     harpoon:list():prev()
--   end)
--
--   vim.keymap.set('n', '<C-S-N>', function()
--     harpoon:list():next()
--   end)
--   -- },
--   -- {
--
--   -- local harpoon = require 'harpoon'
--   -- harpoon:setup {}
--
--   -- basic telescope configuration
--   -- local conf = require('telescope.config').values
--   -- local function toggle_telescope(harpoon_files)
--   --   local file_paths = {}
--   --   for _, item in ipairs(harpoon_files.items) do
--   --     table.insert(file_paths, item.value)
--   --   end
--   --
--   --   require('telescope.pickers')
--   --     .new({}, {
--   --       prompt_title = 'Harpoon',
--   --       finder = require('telescope.finders').new_table {
--   --         results = file_paths,
--   --       },
--   --       previewer = conf.file_previewer {},
--   --       sorter = conf.generic_sorter {},
--   --     })
--   --     :find()
--   -- end
-- end
--
-- return M

-- vim.keymap.set('n', '<C-e>', function()
--   toggle_telescope(harpoon:list())
-- end, { desc = 'Open harpoon window' })

--
-- local harpoon = require("harpoon")
--
-- harpoon:setup({
--     -- Setting up custom behavior for a list named "cmd"
--     "cmd" = {
--
--         -- When you call list:add() this function is called and the return
--         -- value will be put in the list at the end.
--         --
--         -- which means same behavior for prepend except where in the list the
--         -- return value is added
--         --
--         -- @param possible_value string only passed in when you alter the ui manual
--         add = function(possible_value)
--             -- get the current line idx
--             local idx = vim.fn.line(".")
--
--             -- read the current line
--             local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
--             if cmd == nil then
--                 return nil
--             end
--
--             return {
--                 value = cmd,
--                 context = { ... any data you want ... },
--             }
--         end,
--
--         --- This function gets invoked with the options being passed in from
--         --- list:select(index, <...options...>)
--         --- @param list_item {value: any, context: any}
--         --- @param list { ... }
--         --- @param option any
--         select = function(list_item, list, option)
--             -- WOAH, IS THIS HTMX LEVEL XSS ATTACK??
--             vim.cmd(list_item.value)
--         end
--
--     }
-- })

--chat gpt help
-- {
--   'theprimeagen/harpoon',
--   branch = 'harpoon2',
--   dependencies = { 'nvim-lua/plenary.nvim' },
--   config = function()
--     require('harpoon').setup() -- Initialize Harpoon
--   end,
--   keys = {
--     {
--       '<leader>A',
--       function()
--         require('harpoon.mark').add_file()
--       end,
--       desc = 'Add file to Harpoon',
--     },
--     {
--       '<leader>a',
--       function()
--         require('harpoon.ui').toggle_quick_menu()
--       end,
--       desc = 'Toggle Harpoon quick menu',
--     },
--     {
--       '<leader>1',
--       function()
--         require('harpoon.ui').nav_file(1)
--       end,
--       desc = 'Navigate to Harpoon file 1',
--     },
--     {
--       '<leader>2',
--       function()
--         require('harpoon.ui').nav_file(2)
--       end,
--       desc = 'Navigate to Harpoon file 2',
--     },
--     {
--       '<leader>3',
--       function()
--         require('harpoon.ui').nav_file(3)
--       end,
--       desc = 'Navigate to Harpoon file 3',
--     },
--     {
--       '<leader>4',
--       function()
--         require('harpoon.ui').nav_file(4)
--       end,
--       desc = 'Navigate to Harpoon file 4',
--     },
--     {
--       '<leader>5',
--       function()
--         require('harpoon.ui').nav_file(5)
--       end,
--       desc = 'Navigate to Harpoon file 5',
--     },
--   },
-- },

-- end

-- -- harpoon = function()
--       local harpoon_mark = require('harpoon.mark')
--       local harpoon_ui = require('harpoon.ui')
--       local harpoon_telescope = {}

--       harpoon_telescope.marks = function()
--         local marks = harpoon_mark.get_all()
--         local entries = {}

--         for idx, mark in ipairs(marks) do
--           table.insert(entries, {
--             value = mark.filename,
--             ordinal = mark.filename,
--             display = string.format('%d: %s', idx, mark.filename),
--             path = mark.filename,
--             index = idx,
--           })
--         end

-- --         require('telescope.pickers').new({}, {
-- --           prompt_title = 'Harpoon Marks',
-- --           finder = require('telescope.finders').new_table {
-- --             results = entries,
-- --             entry_maker = function(entry)
-- --               return {
-- --                 value = entry,
-- --                 display = entry.display,
-- --                 ordinal = entry.ordinal,
-- --                 path = entry.path,
-- --                 index = entry.index,
-- --               }
-- --             end,
-- --           },
-- --           sorter = require('telescope.config').values.generic_sorter({}),
-- --           attach_mappings = function(_, map)
-- --             map('i', '<CR>', function(bufnr)
-- --               local selection = require('telescope.actions.state').get_selected_entry(bufnr)
-- --               require('telescope.actions').close(bufnr)
-- --               harpoon_ui.nav_file(selection.value.index)
-- --             end)
-- --             map('n', '<CR>', function(bufnr)
-- --               local selection = require('telescope.actions.state').get_selected_entry(bufnr)
-- --               require('telescope.actions').close(bufnr)
-- --               harpoon_ui.nav_file(selection.value.index)
-- --             end)
-- --             return true
-- --           end,
-- --         }):find()
-- --       end

-- --       return harpoon_telescope
-- --     end,
-- --   },

--     for idx, mark in ipairs(marks) do
--       table.insert(entries, {
--         value = mark.filename,
--         ordinal = mark.filename,
--         display = string.format('%d: %s', idx, mark.filename),
--         path = mark.filename,
--         index = idx,
--       })
--     end

--     require('telescope.pickers')
--       .new({}, {
--         prompt_title = 'Harpoon Marks',
--         finder = require('telescope.finders').new_table {
--           results = entries,
--           entry_maker = function(entry)
--             return {
--               value = entry,
--               display = entry.display,
--               ordinal = entry.ordinal,
--               path = entry.path,
--               index = entry.index,
--             }
--           end,
--         },
--         sorter = conf.generic_sorter {},
--         attach_mappings = function(_, map)
--           map('i', '<CR>', function()
--             local selection = action_state.get_selected_entry()
--             actions.close()
--             require('harpoon.ui').nav_file(selection.value.index)
--           end)
--           map('n', '<CR>', function()
--             local selection = action_state.get_selected_entry()
--             actions.close()
--             require('harpoon.ui').nav_file(selection.value.index)
--           end)
--           return true
--         end,
--       })
--       :find()
--   end

local M = {}
--NOTE: this was originally setup using harpoon 1 instead of harpoon2, never uninstalled the original!

function M.test_print()
  print 'Hello from harpoon module test_print!'
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

function M.setup()
  local harpoon = require 'harpoon'
  -- local harpoon_mark = require 'harpoon.mark'
  local harpoon_file = require 'harpoon.list'
  local harpoon_ui = require 'harpoon.ui'
  local conf = require('telescope.config').values
  local telescope = require 'telescope'
  -- local actions = require 'telescope.actions'
  -- local action_state = require 'telescope.actions.state'

  -- REQUIRED
  harpoon:setup()
  -- harpoon.setup {
  --   global_settings = {
  --     -- ["save_on_toggle"] = false,
  --     -- ["save_on_change"] = true,
  --     -- ["enter_on_sendcmd"] = false,
  --     -- ["tmux_autoclose_windows"] = false,
  --     -- ["excluded_filetypes"] = { "harpoon" },
  --     ['mark_branch'] = true,
  --     -- ["tabline"] = false,
  --     -- ["tabline_suffix"] = "   ",
  --     -- ["tabline_prefix"] = "   ",
  --   },
  -- }

  -- Key mappings for Harpoon
  vim.keymap.set('n', '<leader>A', function()
    harpoon_file.add_file()
    -- my_list:add()
  end, { desc = 'Add file to Harpoon' })

  vim.keymap.set('n', '<leader>a', function()
    harpoon_ui.toggle_quick_menu()
  end, { desc = 'Toggle Harpoon quick menu' })

  vim.keymap.set('n', '<leader>Sp', M.toggle_telescope, { desc = 'Open Harpoon window' })

  for i = 1, 5 do
    vim.keymap.set('n', string.format('<leader>%d', i), function()
      -- require('harpoon.ui').nav_file(i)
      harpoon_file.select(i)
    end, { desc = string.format('Navigate to Harpoon file %d', i) })
  end

  -- vim.keymap.set('n', '<leader>Sm', function()
  --   M.get_my_list()
  -- end, { desc = 'Harpoon test print list' })

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
  -- vim.keymap.set('n', '<leader>Sa', function()
  --   toggle_telescope4(harpoon:list())
  -- end, { desc = 'Open Harpoon Telescope Picker' })
end

return M

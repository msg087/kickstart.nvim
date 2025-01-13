return { -- Fuzzy Finder (files, lsp, etc)

  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    --
    --
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Load Harpoon extension
    -- pcall(require('telescope').load_extension, 'harpoon')
    -- pcall(require('telescope').load_extension, 'harpoon2')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.keymap.set('n', '<leader>sd', require('custom.custom_modules.my_telescope').edit_dotfiles, { desc = '[S]earch [D]otFiles' })
    -- vim.keymap.set('n', '<leader>sca', builtin.find_files, { desc = '[S]earch [C]ode [A]WS files' })
    -- vim.keymap.set('n', '<leader>sco', builtin.find_files, { desc = '[S]earch [C]ode [O]b files' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    -- vim.keymap.set('n', '<leader>sc', function()
    --   builtin.find_files { search_dirs = '/mnt/c/code/' }
    -- end, { desc = '[S]earch [C]ode files' })

    -- vim.keymap.set('n', '<leader>sca', function()
    --   builtin.find_files { search_dirs = '/mnt/c/code/aws/' }
    -- end, { desc = '[S]earch [C]ode [A]WS files' })
    --
    -- vim.keymap.set('n', '<leader>sco', function()
    --   builtin.find_files { search_dirs = '/mnt/c/code/ob/' }
    -- end, { desc = '[S]earch [C]ode [O]b files' })
  end,
}

--###### HARPOON
-- local harpoon = require 'harpoon'
-- harpoon:setup()
--
-- -- basic telescope configuration
-- local conf = require('telescope.config').values
-- local function toggle_telescope(harpoon_files)
--   local file_paths = {}
--   for _, item in ipairs(harpoon_files.items) do
--     table.insert(file_paths, item.value)
--   end
--
--   require('telescope.pickers')
--     .new({}, {
--       prompt_title = 'Harpoon',
--       finder = require('telescope.finders').new_table {
--         results = file_paths,
--       },
--       previewer = conf.file_previewer {},
--       sorter = conf.generic_sorter {},
--     })
--     :find()
-- end
--
-- vim.keymap.set('n', '<C-e>', function()
--   toggle_telescope(harpoon:list())
-- end, { desc = 'Open harpoon window' })

--############ Harpoon
-- -- Built-in actions
-- local transform_mod = require('telescope.actions.mt').transform_mod
--
-- -- or create your custom action
-- local my_cool_custom_action = transform_mod({
--   x = function(prompt_bufnr)
--     print("This function ran after another action. Prompt_bufnr: " .. prompt_bufnr)
--     -- Enter your function logic here. You can take inspiration from lua/telescope/actions.lua
--   end,
-- })
--
--

-- local ts_select_dir_for_grep = function(prompt_bufnr)
--   local action_state = require 'telescope.actions.state'
--   local fb = require('telescope').extensions.file_browser
--   local live_grep = require('telescope.builtin').live_grep
--   local current_line = action_state.get_current_line()

--   fb.file_browser {
--     files = false,
--     depth = false,
--     attach_mappings = function(prompt_bufnr)
--       require('telescope.actions').select_default:replace(function()
--         local entry_path = action_state.get_selected_entry().Path
--         local dir = entry_path:is_dir() and entry_path or entry_path:parent()
--         local relative = dir:make_relative(vim.fn.getcwd())
--         local absolute = dir:absolute()

--         live_grep {
--           results_title = relative .. '/',
--           cwd = absolute,
--           default_text = current_line,
--         }
--       end)

--       return true
--     end,
--   }
-- end

-- telescope.setup {
--   pickers = {
--     live_grep = {
--       mappings = {
--         i = {
--           ['<C-f>'] = ts_select_dir_for_grep,
--         },
--         n = {
--           ['<C-f>'] = ts_select_dir_for_grep,
--         },
--       },
--     },
--   },
-- }

-- ##############harpoon stuff some worked some didn;t
-- harpoon2 = function()
--   -- Telescope picker for Harpoon
--   local conf = require('telescope.config').values
--   local harpoon_mark = require 'harpoon.mark'

--   local function toggle_telescope()
--     local marks = harpoon_mark.get_all()
--     local file_paths = {}

--     for _, mark in ipairs(marks) do
--       table.insert(file_paths, mark.filename)
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

--   -- vim.keymap.set('n', '<leader>tH', function()
--   --   require('telescope').extensions.harpoon2.marks()
--   -- end, { desc = '[T]elescope [H]arpoon Marks2' })
--   -- vim.keymap.set('n', '<leader>ta', toggle_telescope, { desc = '[T]elescope [H]arpoon2 Marks' })
-- end,

-- harpoon = function()
--   local harpoon_mark = require 'harpoon.mark'
--   local harpoon_ui = require 'harpoon.ui'
--   local harpoon_telescope = {}

--   harpoon_telescope.marks = function()
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

--   vim.keymap.set('n', '<leader>tH', function()
--     require('telescope').extensions.harpoon.marks()
--   end, { desc = '[T]elescope [H]arpoon Marks' })

--   return harpoon_telescope
-- end,
-- },
-- }

-- require('telescope').setup {
--   -- You can put your default mappings / updates / etc. in here
--   --  All the info you're looking for is in `:help telescope.setup()`
--   --
--   -- defaults = {
--   --   mappings = {
--   --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
--   --   },
--   -- },
--   -- pickers = {}
--   extensions = {
--     ['ui-select'] = {
--       require('telescope.themes').get_dropdown(),
--     },
--   },

-- harpoon = function()
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
--   },

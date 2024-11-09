local M = {}
-- local themes = {}

function M.edit_dotfiles()
  -- local opts = themes.get_dropdown {
  --   winblend = 10,
  --   border = true,
  --   previewer = true,
  --   shorten_path = true,
  -- }

  require('telescope.builtin').find_files {
    shorten_path = true,
    cwd = '~/dotfiles',
    prompt = '~ dotfiles ~',
    no_ignore = true, -- Include ignored files
    hidden = true, -- Optionally include hidden files
    height = 1,

    file_ignore_patterns = { 'nvim/', 'node_modules', '.git' },

    -- layout_strategy = 'horizontal',
    layout_strategy = 'center',
    layout_options = {
      preview_width = 0.75,
      height = 3,
    },
  }
end

return M

-- {
--
--   callback = function(event)
--   function()
--     local map = function(keys, func, desc)
--       -- vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--       vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--     end
--
--     -- local telescope = require("telescope.builtin")
--     -- map("n", "<leader>si", function()
--     --   telescope.live_grep({
--     --     additional_args = function()
--     --       return { "--no-ignore" }
--     --     end,
--     --   })
--     -- end, { desc = "Live grep for all files" })
--
--     map('<leader>sd', function()
--       local telescope = require 'custom.config.tele_function'
--       telescope.edit_dotfiles()
--       -- telescope.find_files({
--       --   no_ignore = true, -- Include ignored files
--       --   hidden = true, -- Optionally include hidden files
--       -- })
--     end, { desc = 'Edit [D]otFiles' })
--   end
--   end
-- },
-- {
--   vim.keymap.set('n', '<leader>sd', function()
--     builtin.find_files { cwd = '~/dotfiles/*', hidden = true, no_ignore = false }
--     -- file_ignore_patterns = { 'node_modules', '.git' }
--   end, { desc = '[S]earch [D]ot files' }),
-- },

-- {
--   function()
--     local map = function(mode, keys, func, desc) end
--
--     local telescope = require 'custom.config.tele_function'
--     -- map('n', '<leader>si', function()
--     --   telescope.live_grep {
--     --     additional_args = function()
--     --       return { '--no-ignore' }
--     --     end,
--     --   }
--     -- end, { desc = 'Live grep for all files' })
--
--     -- vim.keymap.set('n', '<leader>fi', function()
--     --   telescope.find_files {
--     --     no_ignore = true, -- Include ignored files
--     --     hidden = true, -- Optionally include hidden files
--     --   }
--     -- end, { desc = 'Find all files' })
--
--     map('n', '<leader>fi', function()
--       telescope.edit_dotfiles() {
--         -- no_ignore = true, -- Include ignored files
--         -- hidden = true, -- Optionally include hidden files
--       }
--     end, { desc = 'Find all files' })
--   end,
--
--   -- vim.keymap.set('n', '<leader>si', <cmd>lua require('custom.config.tele_function').edit_dotfiles(), { desc = '[S]earch [H]elp' })
--   -- noremap <leader> si <cmd> lua require('custom.config.tele_function').edit_dotfiles()
--
--   -- vim.keymap <leader>
--   -- vim.keymap.set('n', '<leader>sca', function()
--   --   builtin.find_files { search_dirs = '/mnt/c/code/aws/' }
--   -- end, { desc = '[S]earch [C]ode [A]WS files' })
-- },

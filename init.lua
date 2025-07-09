--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.mouse = 'a'
vim.opt.scrolloff = 7 -- Minimal number of screen lines to keep above and below the cursor.

vim.api.nvim_set_option_value('colorcolumn', '80', {})
-- vim.api.nvim_set_option_value('colorcolumn', '100', {})
-- vim.api.nvim_set_option_value('colorcolumn', '120', {})

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

--  Remove this option if you want your OS clipboard to remain independent.
vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

vim.opt.undofile = true --undo history saved

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

-- Displays which-key popup sooner
vim.opt.timeoutlen = 400 --changed from 300 to 400

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split' --shows partially off screen results in a preview pane as you find/replace

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[D', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']D', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  -- See `:help gitsigns` to understand what the configuration keys do
  --
  -- { -- Adds git related signs to the gutter, as well as utilities for managing changes
  --   'lewis6991/gitsigns.nvim',
  --   opts = {
  --     signs = {
  --       add = { text = '+' },
  --       change = { text = '~' },
  --       delete = { text = '_' },
  --       topdelete = { text = '‾' },
  --       changedelete = { text = '~' },
  --     },
  --   },
  -- },
  --

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  -- { -- Useful plugin to show you pending keybinds.
  --   'folke/which-key.nvim',
  --   event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  --   config = function() -- This is the function that runs, AFTER loading
  --     require('which-key').setup()
  --
  --     require('custom.config.which-key').setup()
  --
  --     -- Document existing key chains
  --     require('which-key').register {
  --       ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  --       ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  --       ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  --       ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  --       ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  --       ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  --       ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  --     }
  --     -- visual mode
  --     require('which-key').register({
  --       ['<leader>h'] = { 'Git [H]unk' },
  --     }, { mode = 'v' })
  --   end,
  -- },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },

        -- Database
        { '<leader>S', group = 'Database', nowait = false, remap = false },
        { '<leader>Sf', '<Cmd>DBUIFindBuffer<Cr>', desc = 'Find buffer', nowait = false, remap = false },
        { '<leader>Sq', '<Cmd>DBUILastQueryInfo<Cr>', desc = 'Last query info', nowait = false, remap = false },
        { '<leader>Sr', '<Cmd>DBUIRenameBuffer<Cr>', desc = 'Rename buffer', nowait = false, remap = false },
        { '<leader>Su', '<Cmd>DBUIToggle<Cr>', desc = 'Toggle UI', nowait = false, remap = false },

        --markdown
        { '<leader>m', group = 'Markdown', nowait = false, remap = false },
        { '<leader>mm', '<Cmd>MarkdownPreview<Cr>', desc = 'Show MD Preview', nowait = false, remap = false },
        { '<leader>ms', '<Cmd>MarkdownPreviewStop<Cr>', desc = 'Stop MD Preview', nowait = false, remap = false },
      },
    },
  },
  {
    --   config = function() -- This is the function that runs, AFTER loading
    --   function()
    --   require('custom.config.which-key').setup()
    -- end,
  },

  --
  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin
  --
  -- init.lua:
  --     {
  --     'nvim-telescope/telescope.nvim', tag = '0.1.8',
  -- -- or                              , branch = '0.1.x',
  --       dependencies = { 'nvim-lua/plenary.nvim' }
  --     }
  --
  --

  -- { -- Fuzzy Finder (files, lsp, etc)
  --   'nvim-telescope/telescope.nvim',
  --   event = 'VimEnter',
  --   branch = '0.1.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     { -- If encountering errors, see telescope-fzf-native README for installation instructions
  --       'nvim-telescope/telescope-fzf-native.nvim',
  --
  --       -- `build` is used to run some command when the plugin is installed/updated.
  --       -- This is only run then, not every time Neovim starts up.
  --       build = 'make',
  --
  --       -- `cond` is a condition used to determine whether this plugin should be
  --       -- installed and loaded.
  --       cond = function()
  --         return vim.fn.executable 'make' == 1
  --       end,
  --     },
  --     { 'nvim-telescope/telescope-ui-select.nvim' },
  --
  --     -- Useful for getting pretty icons, but requires a Nerd Font.
  --     { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  --   },
  --   config = function()
  -- --     -- Telescope is a fuzzy finder that comes with a lot of different things that
  -- --     -- it can fuzzy find! It's more than just a "file finder", it can search
  -- --     -- many different aspects of Neovim, your workspace, LSP, and more!
  -- --     --
  -- --     -- The easiest way to use Telescope, is to start by doing something like:
  -- --     --  :Telescope help_tags
  -- --     --
  -- --     -- After running this command, a window will open up and you're able to
  -- --     -- type in the prompt window. You'll see a list of `help_tags` options and
  -- --     -- a corresponding preview of the help.
  -- --     --
  -- --     -- Two important keymaps to use while in Telescope are:
  --      -- - Insert mode: <c-/>
  --      -- - Normal mode: ?
  -- --     --
  -- --     -- This opens a window that shows you all of the keymaps for the current
  -- --     -- Telescope picker. This is really useful to discover what Telescope can
  -- --     -- do as well as how to actually do it!
  -- --
  -- --     -- [[ Configure Telescope ]]
  -- --     -- See `:help telescope` and `:help telescope.setup()`
  --     require('telescope').setup {
  --       -- You can put your default mappings / updates / etc. in here
  --       --  All the info you're looking for is in `:help telescope.setup()`
  --       --
  --       defaults = {
  --         mappings = {
  --           i = { ['<c-enter>'] = 'to_fuzzy_refine' },
  --         },
  --       -- },
  --       -- pickers = {}
  --       extensions = {
  --         ['ui-select'] = {
  --           require('telescope.themes').get_dropdown(),
  --         },
  --       },
  --     },
  -- --
  -- --     -- Enable Telescope extensions if they are installed
  --     -- pcall(require('telescope').load_extension, 'fzf')
  --     -- pcall(require('telescope').load_extension, 'ui-select')
  -- --
  -- --     -- See `:help telescope.builtin`
  -- --     local builtin = require 'telescope.builtin'
  -- --     vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  -- --     vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  -- --     vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  -- --     vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  -- --     vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  -- --     vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  -- --     vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  -- --     vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  -- --     vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  -- --     vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  -- --
  -- --     -- vim.keymap.set('n', '<leader>sca', builtin.find_files, { desc = '[S]earch [C]ode [A]WS files' })
  -- --     -- vim.keymap.set('n', '<leader>sco', builtin.find_files, { desc = '[S]earch [C]ode [O]b files' })
  -- --
  -- --     -- Slightly advanced example of overriding default behavior and theme
  -- --     vim.keymap.set('n', '<leader>/', function()
  -- --       -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  -- --       builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
  -- --         winblend = 10,
  -- --         previewer = false,
  -- --       })
  --     -- end, { desc = '[/] Fuzzily search in current buffer' })
  -- --
  -- --     -- It's also possible to pass additional configuration options.
  -- --     --  See `:help telescope.builtin.live_grep()` for information about particular keys
  --     -- vim.keymap.set('n', '<leader>s/', function()
  --     --   builtin.live_grep {
  --     --     grep_open_files = true,
  --     --     prompt_title = 'Live Grep in Open Files',
  --     --   }
  --     -- end, { desc = '[S]earch [/] in Open Files' })
  -- --
  -- --     -- Shortcut for searching your Neovim configuration files
  -- --     vim.keymap.set('n', '<leader>sn', function()
  -- --       builtin.find_files { cwd = vim.fn.stdpath 'config' }
  -- --     end, { desc = '[S]earch [N]eovim files' })
  -- --
  -- --     -- vim.keymap.set('n', '<leader>sc', function()
  -- --     --   builtin.find_files { search_dirs = '/mnt/c/code/' }
  -- --     -- end, { desc = '[S]earch [C]ode files' })
  -- --
  -- --     -- vim.keymap.set('n', '<leader>sca', function()
  -- --     --   builtin.find_files { search_dirs = '/mnt/c/code/aws/' }
  -- --     -- end, { desc = '[S]earch [C]ode [A]WS files' })
  -- --     --
  -- --     -- vim.keymap.set('n', '<leader>sco', function()
  -- --     --   builtin.find_files { search_dirs = '/mnt/c/code/ob/' }
  -- --     -- end, { desc = '[S]earch [C]ode [O]b files' })
  --   end,
  -- },
  --

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      --   -- Load the colorscheme here.
      --   -- Like many other themes, this one has different styles, and you could load
      --   -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
      --   -- vim.cmd.colorscheme 'tokyonight-moon'
      --
      --   -- You can configure highlights by doing something like:
      --   vim.cmd.hi 'Comment gui=none'
      --
      --   -- vim.cmd 'colorscheme material',
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  -- { -- Highlight, edit, and navigate code
  --   'nvim-treesitter/nvim-treesitter',
  --   build = ':TSUpdate',
  --   opts = {
  --     ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'typescript', 'tsx', 'javascript', 'sql' },
  --     -- Autoinstall languages that are not installed
  --     auto_install = true,
  --     highlight = {
  --       enable = true,
  --       additional_vim_regex_highlighting = { 'ruby', 'sql' },
  --     },
  --     indent = { enable = true, disable = { 'ruby' } },
  --   },
  --   config = function(_, opts)
  --     -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  --
  --     -- Prefer git instead of curl in order to improve connectivity in some environments
  --     require('nvim-treesitter.install').prefer_git = true
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('nvim-treesitter.configs').setup(opts)
  --
  --     -- There are additional nvim-treesitter modules that you can use to interact
  --     -- with nvim-treesitter. You should go explore a few and see what interests you:
  --     --
  --     --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --     --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --     --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  --   end,
  -- },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },

  -- tailwind-tools.lua
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- optional
      'neovim/nvim-lspconfig', -- optional
    },
    opts = {}, -- your configuration
  },
  {
    'windwp/nvim-ts-autotag',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

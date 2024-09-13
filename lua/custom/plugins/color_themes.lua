-- return {
--   { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
--   {
--     'baliestri/aura-theme',
--     lazy = false,
--     priority = 1000,
--     config = function(plugin)
--       vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
--       vim.cmd [[colorscheme aura-dark]]
--       -- vim.cmd [[colorscheme aura-dark]]
--       -- Name	Key
--       -- Aura Dark	aura-dark
--       -- Aura Dark Soft Text	aura-dark-soft-text
--       -- Aura Soft Dark	aura-soft-dark
--       -- Aura Soft Dark Soft Text	aura-soft-dark-soft-text
--     end,
--   },
--   -- :colorscheme aura-dark " Or any Aura theme available
-- }
return {
  -- -- { 'marko-cerovac/material.nvim', opts = {} }
  -- {
  --   -- vim.cmd 'let g:material_style="deep ocean"',
  --   vim.cmd 'let g:material_style="oceanic"',
  -- },
  -- {
  --
  require('material').setup {
    priority = 1200, -- Make sure to load this before all the other start plugins.
    contrast = {
      terminal = true, -- Enable contrast for the built-in terminal
      sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
      popup_menu = true,
      floating_windows = true, -- Enable contrast for floating windows
      cursor_line = true, -- Enable darker background for the cursor line
      lsp_virtual_text = true, -- Enable contrasted background for lsp virtual text
      non_current_windows = true, -- Enable contrasted background for non-current windows
      filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
    },

    styles = { -- Give comments style such as bold, italic, underline etc.
      comments = { [[ italic = true ]] },
      strings = { [[ bold = true ]] },
      keywords = { [[ underline = true ]] },
      functions = { [[ bold = true, undercurl = true ]] },
      variables = {},
      operators = {},
      types = {},
    },

    plugins = { -- Uncomment the plugins that you use to highlight them
      -- Available plugins:
      -- "coc",
      -- "colorful-winsep",
      -- "dap",
      -- "dashboard",
      -- "eyeliner",
      -- "fidget",
      -- "flash",
      -- "gitsigns",
      'harpoon',
      -- "hop",
      -- "illuminate",
      -- "indent-blankline",
      -- "lspsaga",
      -- "mini",
      -- "neogit",
      -- "neotest",
      'neo-tree',
      -- "neorg",
      -- "noice",
      'nvim-cmp',
      -- "nvim-navic",
      -- "nvim-tree",
      -- "nvim-web-devicons",
      -- "rainbow-delimiters",
      -- "sneak",
      'telescope',
      -- "trouble",
      'which-key',
      -- "nvim-notify",
    },

    disable = {
      colored_cursor = false, -- Disable the colored cursor
      borders = false, -- Disable borders between vertically split windows
      background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
      term_colors = false, -- Prevent the theme from setting terminal colors
      eob_lines = false, -- Hide the end-of-buffer lines
    },

    high_visibility = {
      lighter = false, -- Enable higher contrast text for lighter style
      darker = true, -- Enable higher contrast text for darker style
    },

    lualine_style = 'default', -- Lualine style ( can be 'stealth' or 'default' )

    async_loading = true, -- Load parts of the theme asynchronously for faster startup (turned on by default)

    custom_colors = nil, -- If you want to override the default colors, set this to a function

    custom_highlights = {}, -- Overwrite highlights with your own

    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'tokyonight-night'
      -- vim.cmd.colorscheme 'tokyonight-moon'

      -- vim.cmd 'let g:material_style="deep ocean"'
      -- vim.cmd 'let g:material_style="deep ocean"'
      -- vim.cmd 'let g:material_style="Darker"'
      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'

      -- vim.cmd 'colorscheme material'
    end,
  },

  require('material').setup {
    custom_colors = function(colors)
      colors.syntax.comments = '#00FF00'
      -- colors.editor.bg = "#SOME_COLOR",
      -- colors.main.blue = "#SOME_COLOR",
    end,
  },
  -- { require('material.functions').find_style() },
}

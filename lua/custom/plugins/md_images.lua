-- ---@nodoc
-- _G.vim = _G.vim or {} --[[@as table]]
-- local has_luarocks = vim.fn.executable 'luarocks' == 1
--
-- Example for configuring Neovim to load user-installed installed Lua rocks:
-- package.path = package.path .. ';' .. vim.fn.expand '$HOME' .. '/.luarocks/share/lua/5.1/?/init.lua'
-- package.path = package.path .. ';' .. vim.fn.expand '$HOME' .. '/.luarocks/share/lua/5.1/?.lua'

return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { 'magick' },
    },
  },

  {
    '3rd/image.nvim',
    -- cond = has_luarocks,
    -- rocks = { 'magick == 1.6.0' },
    -- dependencies = { 'luarocks.nvim' },
    ft = { 'markdown', 'vimwiki', 'png', 'jpeg', 'jpg', 'gif', 'webp', 'avif' },
    -- build = false,
    config = function()
      require('image').setup {
        backend = 'sixel', -- or "ueberzug" / "sixel" "kitty"
        kitty_method = 'normal', -- default used internally

        processor = 'magick_rock', --or magick_cli or magick_rock
        -- processor = 'magick_cli', --or magick_cli or magick_rock

        -- 🔑 DO NOT enable markdown integrations for Molten ???
        -- integrations = {},
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            only_render_image_at_cursor_mode = 'popup', -- or "inline" or 'popup'
            floating_windows = false, -- if true, images will be rendered in floating markdown windows
            filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
          },
          -- neorg = {
          --   enabled = true,
          --   filetypes = { "norg" },
          -- },
          -- typst = {
          --   enabled = true,
          --   filetypes = { "typst" },
          -- },
          html = {
            enabled = false,
          },
          css = {
            enabled = false,
          },
        },

        -- REQUIRED to prevent crashes
        max_width = 300,
        max_height = 50,
        molten_wrap_output = true,
        -- molten_virtual_text_output = true,
        -- molten_virt_lines_off_by_1 = true,

        -- REQUIRED for Molten floating output windows
        max_width_window_percentage = math.huge,
        max_height_window_percentage = math.huge,

        window_overlap_clear_enabled = true,
        -- window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },

        -- max_width = nil,
        -- max_height = nil,
        -- max_width_window_percentage = nil,
        -- max_height_window_percentage = 50,
        scale_factor = 1.0,
        -- window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'snacks_notif', 'scrollview', 'scrollview_sign' },
        editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' }, -- render image files as images when opened
      }
    end,
  },

  {
    '3rd/diagram.nvim',
    enabled = false,
    ft = { 'markdown', 'vimwiki' },
    dependencies = {
      { '3rd/image.nvim' },
    },
    opts = { -- you can just pass {}, defaults below
      events = {
        render_buffer = { 'InsertLeave', 'BufWinEnter', 'TextChanged' },
        clear_buffer = { 'BufLeave', 'InsertEnter' },
      },
      renderer_options = {
        mermaid = {
          background = 'transparent', -- nil | "transparent" | "white" | "#hex"
          theme = 'dark', -- nil | "default" | "dark" | "forest" | "neutral"
          scale = 1, -- nil | 1 (default) | 2  | 3 | ...
          width = nil, -- nil | 800 | 400 | ...
          height = nil, -- nil | 600 | 300 | ...
          cli_args = nil, -- nil | { "--no-sandbox" } | { "-p", "/path/to/puppeteer" } | ...
        },
        plantuml = {
          charset = nil,
          cli_args = nil, -- nil | { "-Djava.awt.headless=true" } | ...
        },
        d2 = {
          theme_id = nil,
          dark_theme_id = nil,
          scale = nil,
          layout = nil,
          sketch = nil,
          cli_args = nil, -- nil | { "--pad", "0" } | ...
        },
        gnuplot = {
          size = nil, -- nil | "800,600" | ...
          font = nil, -- nil | "Arial,12" | ...
          theme = nil, -- nil | "light" | "dark" | custom theme string
          cli_args = nil, -- nil | { "-p" } | { "-c", "config.plt" } | ...
        },
      },
    },
  },
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'vim',
          'vimdoc',
          'typescript',
          'tsx',
          'javascript',
          'sql',
          'python',
          'markdown_inline',
          'yaml',
          'json',
          'csv',
          'dockerfile',
          'jq',
          'make',
          'nginx',
          'powershell',
          'regex',
          'rust',
          'terraform',
          'tsv',
          'toml',
          'query',
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,

          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          -- additional_vim_regex_highlighting = { 'ruby', 'sql' },
        },
        indent = {
          enable = { enable = true, disable = { 'ruby' } },
        },
      }

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true

      -- This can go in your `init.lua` or a plugin setup block
      -- vim.treesitter.query.set("python", "injections", [[
      -- (
      --   (string
      --     (string_content) @sql_content
      --     (#match? @sql_content "^[\\n\\r\\t ]*--\\s*sql")
      --     (#set! injection.language "sql")
      --   )
      -- )
      -- ]])
      --

      -- ---@diagnostic disable-next-line: missing-fields
      -- require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}

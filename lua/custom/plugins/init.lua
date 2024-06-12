-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'wakatime/vim-wakatime',
  lazy = false,

  'github/copilot.vim',
  --
  -- comment toggle
  -- consider terrortylor/nvim-comment as well
  'tpope/vim-commentary',

  -- Database
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
-- test gpg signing in wsl
--

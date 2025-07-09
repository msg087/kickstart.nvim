return {

  -- supermaven
  {
      "supermaven-inc/supermaven-nvim",
      config = function()
        require("supermaven-nvim").setup({
          keymaps = {
            accept_suggestion = "<M-.>",
          },
        })
      end,
    },

}

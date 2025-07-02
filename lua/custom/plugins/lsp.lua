return {
  {
require('lspconfig').gopls.setup({
  settings = {
    gopls = {
      staticcheck = true,
    },
  },
})
  },
}

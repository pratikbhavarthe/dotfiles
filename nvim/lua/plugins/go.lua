-- gopls: staticcheck, gofumpt, auto-imports.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
              usePlaceholders = true,
              completeUnimported = true,
              gofumpt = true,
            },
          },
        },
      },
    },
  },
}

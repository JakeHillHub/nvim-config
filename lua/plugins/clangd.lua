return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- Use the installed system server; do not install another via Mason.
          mason = false,
          cmd = { "/usr/sbin/clangd", "--background-index" },
        },
      },
    },
  },
}

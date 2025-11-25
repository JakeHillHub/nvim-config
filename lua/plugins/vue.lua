return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 1. Manually construct the path to avoid the "nil value" crash
      -- This assumes standard Mason install location
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local vue_language_server_path = mason_path .. "/packages/vue-language-server/node_modules/@vue/language-server"

      -- 2. Configure TypeScript (ts_ls) to use the Vue plugin
      opts.servers.ts_ls = vim.tbl_deep_extend("force", opts.servers.ts_ls or {}, {
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue" },
            },
          },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })

      -- 3. Configure Volar
      opts.servers.volar = {
        capabilities = {
          documentFormattingProvider = false, -- Let Prettier handle formatting
          documentRangeFormattingProvider = false,
        },
        init_options = {
          vue = {
            hybridMode = true,
          },
        },
      }
    end,
  },
}

return {
  -- This targets the snacks.nvim plugin configuration
  "folke/snacks.nvim",
  -- Set `opts` to override the default settings
  opts = {
    picker = {
      sources = {
        -- Target the 'explorer' source specifically
        explorer = {
          win = {
            list = {
              -- 'wo' stands for window options (vim.wo)
              wo = {
                number = true, -- Enable absolute line number
                relativenumber = true, -- Enable relative line number
              },
            },
          },
        },
      },
    },
  },
}

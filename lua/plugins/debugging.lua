return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "jedrzejboczar/nvim-dap-cortex-debug", "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    config = function()
      require("dap-cortex-debug").setup({
        debug = false,
        extension_path = vim.fn.stdpath("data") .. "/mason/packages/cortex-debug/extension",
      })
    end,
  },
}

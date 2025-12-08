return {
  {
    "mfussenegger/nvim-dap",
    config = function() end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: Toggle UI",
      },
      {
        "<leader>dr",
        function()
          require("dapui").open({ reset = true })
        end,
        desc = "Debug: Reset Layout",
      },
    },
  },
  {
    "jedrzejboczar/nvim-dap-cortex-debug",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-cortex-debug").setup({
        debug = false,
        extension_path = vim.fn.stdpath("data") .. "/mason/packages/cortex-debug/extension",
      })
    end,
  },
}

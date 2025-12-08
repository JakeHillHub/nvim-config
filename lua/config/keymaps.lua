-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Basic Debugging Keymaps (VS Code Style)
map("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Debug: Start/Continue" })
map("n", "<F7>", function()
  require("dap").step_into()
end, { desc = "Debug: Step Into" })
map("n", "<F6>", function()
  require("dap").step_over()
end, { desc = "Debug: Step Over" })
map("n", "<F8>", function()
  require("dap").step_out()
end, { desc = "Debug: Step Out" })
map("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
map("n", "<F10>", function()
  require("dap").terminate()
end, { desc = "Debug: Terminate Session" })

-- Toggle Debug UI
vim.keymap.set("n", "<Leader>du", function()
  require("dapui").toggle()
end, { desc = "Debug: Toggle UI" })

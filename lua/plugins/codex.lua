return {
  "johnseth97/codex.nvim",
  cmd = { "Codex", "CodexToggle" },
  keys = {
    {
      '<leader>c"',
      function()
        require("codex").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle Codex",
    },
  },
  opts = {
    keymaps = {
      toggle = nil,
      quit = "<C-q>",
    },
    border = "rounded",
    autoinstall = false,
    panel = false,
    use_buffer = false,
  },
}

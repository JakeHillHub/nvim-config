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
  init = function()
    local group = vim.api.nvim_create_augroup("CodexTerminalKeymaps", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "codex",
      callback = function(event)
        local close = function()
          require("codex").close()
        end

        for _, key in ipairs({ "<C-/>", "<C-_>" }) do
          vim.keymap.set({ "n", "t" }, key, close, {
            buffer = event.buf,
            desc = "Hide Codex",
          })
        end
      end,
    })
  end,
  opts = {
    keymaps = {
      toggle = nil,
      quit = nil,
    },
    border = "rounded",
    width = 0.35,
    autoinstall = false,
    panel = true,
    use_buffer = false,
  },
}

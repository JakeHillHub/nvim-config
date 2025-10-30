return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  config = function()
    local builtin = require("telescope.builtin")
    vim.keymap.set(
      "n",
      "<leader>ff",
      builtin.current_buffer_fuzzy_find,
      { desc = "Telescope fuzzy find in current buffer" }
    )
  end,
}

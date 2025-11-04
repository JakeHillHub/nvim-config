-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.keymap.set("i", "lk", "<ESC>")
vim.keymap.set("i", "df", "<C-R><C-O>")
vim.opt.timeoutlen = 100

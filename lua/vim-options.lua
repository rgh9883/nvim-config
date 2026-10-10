-- Make sure to setup `mapleader` and `maplocalleader` before
-- any <leader> mappings (here and in lazy.nvim plugins) so they bind correctly.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- normal mode, format current buffer
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format()
end, { desc = "Format code" })

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.winblend = 10
vim.opt.pumblend = 10

-- Disable arrow keys in normal, insert, and visual mode
local opts = { noremap = true, silent = true }

vim.keymap.set({"n", "i", "v"}, "<Up>", "<Nop>", opts)
vim.keymap.set({"n", "i", "v"}, "<Down>", "<Nop>", opts)
vim.keymap.set({"n", "i", "v"}, "<Left>", "<Nop>", opts)
vim.keymap.set({"n", "i", "v"}, "<Right>", "<Nop>", opts)

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })

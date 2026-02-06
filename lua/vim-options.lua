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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable arrow keys in normal, insert, and visual mode
local opts = { noremap = true, silent = true }

vim.keymap.set({"n", "i", "v"}, "<Up>", "<Nop>", opts)
vim.keymap.set({"n", "i", "v"}, "<Down>", "<Nop>", opts)
vim.keymap.set({"n", "i", "v"}, "<Left>", "<Nop>", opts)
vim.keymap.set({"n", "i", "v"}, "<Right>", "<Nop>", opts)

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })

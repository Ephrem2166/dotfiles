vim.g.mapleader = " "
vim.g.maplocalleader = ";"
local map = vim.keymap.set
-- Basic Setting
map("n", "<leader>:", vim.cmd.Ex)
map("n", "<leader>qq", "<cmd>qa<cr>")
map("i", "jk", "<ESC>")
-- Buffers
map("n", "<leader>bl", "<cmd>bnext<CR>")
map("n", "<leader>bp", "<cmd>bnext<cr>")

map("n", "<leader>bb", "<cmd>e #<cr>")
map("n", "<leader>bd", "<cmd>bdelete<cr>")

-- Windows
map("n", "<leader>ws", "<C-W>s")
map("n", "<leader>wv", "<C-W>v")
map("n", "<leader>wd", "<C-W>c")

map("n", "<C-left>", "<C-W>h")
map("n", "<C-right>", "<C-W>l")
map("n", "<C-up>", "<C-W>k")
map("n", "<C-down>", "<C-W>j")

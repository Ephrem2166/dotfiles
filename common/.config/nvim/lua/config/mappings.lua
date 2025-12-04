vim.g.mapleader = " "
vim.g.maplocalleader = " "
local map = vim.keymap.set
-- Basic Setting
map("n", "<leader>:", vim.cmd.Ex)
map("n", "<leader>qq", "<cmd>qa<cr>")
-- Buffers
map("n", "<leader>bl", "<cmd>bnext<CR>")
map("n", "<leader>bp", "<cmd>bnext<cr>")
map("n", "<leader>bb", "<cmd>e #<cr>")
map("n", "<leader>bd", "<cmd>bdelete<cr>")

-- Windows
map("n", "<leader>ws", "<C-W>s")
map("n", "<leader>wv", "<C-W>v")
map("n", "<leader>wd", "<C-W>c")

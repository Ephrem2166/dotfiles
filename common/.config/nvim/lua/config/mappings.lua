vim.g.mapleader = " "
vim.g.maplocalleader = " "
local map = vim.keymap.set
-- Basic Setting
map("n", "<leader>:", vim.cmd.Ex)
map("n", "<leader>qq", "<cmd>qa<cr>")
map("i", "jk", "<ESC>")
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
-- Buffers
map("n", "<leader>bl", "<cmd>bnext<cr>")
map("n", "<leader>bp", "<cmd>bprev<cr>")
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

-- better navigation in insert mode
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>")
map("n", "<leader>tq", "<cmd>tabclose<cr>")
map("n", "<leader>t.", "<cmd>tabnext<cr>")
map("n", "<leader>t,", "<cmd>tabprevious<cr>")

-- Open terminal in a new vertical split
map("n", "<leader>tt", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 20)

	job_id = vim.bo.channel
end)

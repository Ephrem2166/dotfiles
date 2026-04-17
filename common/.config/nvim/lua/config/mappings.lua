vim.g.mapleader = " "
vim.g.maplocalleader = " "
local map = vim.keymap.set

-- General Setting
map("n", "<leader>:", vim.cmd.Ex)
map({ "i", "n", "v" }, "jk", "<Esc>")
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear Highlights" })
-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Alternative way to exit
map({ "n", "v", "i" }, "<M-q>", "<cmd>q!<cr>", { desc = "Quit All" })
map("n", "<leader>qq", ":qa<cr>", { desc = "Quit All Files", noremap = true, silent = true })
map("n", "<leader>q", ":q<cr>", { desc = "Quit File", noremap = true, silent = true })

-- Write Files
map("n", "<leader>w", ":w<cr>", { desc = "Write File", noremap = true, silent = true })
map("n", "<leader>ww", ":wa<cr>", { desc = "Write All Files", noremap = true, silent = true })
map("n", "<leader>m", ":messages<cr>", { desc = "Show Messages", noremap = true, silent = true })

-- Set up a keymap to refresh the current buffer
map("n", "<leader>br", function()
	-- Reloads the file to reflect the changes
	vim.cmd("edit!")
	print("Buffer reloaded")
end, { desc = "Reload current buffer" })

-- Open NVIM config
map("n", "<leader>s.", ":e $MYVIMRC<CR>", { desc = "Open NVIM Config" })

-- CD to open file directory
map("n", "<leader>cd", ":cd %:p:h<CR>", {
	desc = "Change working directory to current File",
})

-- Buffers
map("n", "<leader>bl", "<cmd>bnext<cr>")
map("n", "<leader>bp", "<cmd>bprev<cr>")
map("n", "<leader>bb", "<cmd>e #<cr>")
map("n", "<leader>bd", "<cmd>bdelete<cr>")
map("n", "<leader>bn", "<cmd>enew<cr>")
-- Source buffer
map("n", "<leader><leader>S", ":source %<cr>", { desc = "Source Buffer", noremap = true, silent = true })

-- Windows
map("n", "<leader>ws", "<C-W>s", { desc = "Split Window Horizonatally" })
map("n", "<leader>wv", "<C-W>v", { desc = "Split Window Vertically" })
map("n", "<leader>wd", "<C-W>c", { desc = "Close Window" })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

map({ "n", "v" }, "<Leader>wl", "<cmd>vertical resize +5<cr>", { desc = "Increase window width", remap = false })
map({ "n", "v" }, "<Leader>wh", "<cmd>vertical resize -5<cr>", { desc = "Increase window width", remap = false })

-- better navigation in insert mode
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- make HJKL behave like hjkl but with bigger distance
map({ "n", "x" }, "J", "6gj")
map({ "n", "x" }, "K", "6gk")

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader>t.", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader>tq", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader>t0", "<cmd>tabfirst<cr>", { desc = "First Tab" })

-- better up/down - allows moving to wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Comment
map("n", "<leader>c/", "gcc", { desc = "󰆈 Comment line", remap = true })

-- Open terminal in a new vertical split
map("n", "<leader>tt", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 20)

	job_id = vim.bo.channel
end, { desc = "Open Terminal Vertically" })

-- Quickfix
map("n", "<leader>qo", ":copen<CR>", {
	desc = "Open quickfix list",
})

map("n", "<leader>qn", ":cnext<CR>", {
	desc = "Next item on quickfix list",
})

map("n", "<leader>qp", ":cprev<CR>", {
	desc = "Previous item on quickfix list",
})

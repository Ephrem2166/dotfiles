vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({

	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
	signs_staged = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
	},
})

-- Git Signs setup
local gs = require("gitsigns")
gs.setup()
vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Git - preview hunk" })
vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Git - stage hunk" })
vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Git - unstage hunk" })
vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Git - reset hunk" })
vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Git - toggle current line blame" })
vim.keymap.set("n", "<leader>gdt", gs.diffthis, { desc = "Git - diffview current file" })

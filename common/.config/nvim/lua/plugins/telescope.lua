return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local map = vim.keymap.set
		require("telescope").setup()
		map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "telescope buffers" })
		map("n", "<leader>fB", "<cmd>Telescope builtin<cr>", { desc = "telescope builtin" })
		map("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "telescope colorschemes" })
		map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
		map("n", "<leader>fF", "<cmd>Telescope fd<cr>", { desc = "telescope fd" })
		map("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
		map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
		map("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "telescope man pages" })
		map("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "telescope register" })
		map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "telescope keymap" })
		map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
		map("n", "<leader>fv", "<cmd>Telescope vim_options<cr>", { desc = "telescope vim options" })
		map(
			"n",
			"<leader>fz",
			"<cmd>Telescope current_buffer_fuzzy_find<CR>",
			{ desc = "telescope find in current buffer" }
		)
		map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
		map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
		map("n", "<leader>gt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
	end,
}

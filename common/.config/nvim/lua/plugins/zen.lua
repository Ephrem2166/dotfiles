return {
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 1,
					height = 0.9,
					width = 0.8,
					options = {
						number = false,
						relativenumber = false,
						signcolumn = "no",
						list = false,
						cursorline = false,
					},
				},
			})
			vim.keymap.set("n", "<leader>tz", "<cmd>ZenMode<cr>")

			require("twilight").setup({
				context = -1,
				treesitter = true,
			})
		end,
	},

	{
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup({
				context = -1,
				treesitter = true,
			})
		end,
	},
}

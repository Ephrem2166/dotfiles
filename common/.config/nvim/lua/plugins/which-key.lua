return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
	},
	config = function()
		require("which-key").setup({
			icons = {
				rules = false,
				separator = "➜",
				group = "󰹍 ",
			},
			show_keys = false,
			show_help = false, -- show a help message in the command line for using WhichKey
			layout = {
				align = "center",
			},
			win = {
				border = "bold",
				title = false,
				padding = { 1, 1 }, -- extra window padding [top/bottom, right/left]
				no_overlap = true,
			},
		})
	end,
}

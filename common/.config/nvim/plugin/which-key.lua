vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

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

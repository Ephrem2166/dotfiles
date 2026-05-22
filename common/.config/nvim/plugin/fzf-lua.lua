vim.pack.add({
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("fzf-lua").setup({
	winopts = {
		height = 0.85,
		width = 0.80,
		row = 0.35,
		col = 0.50,
		border = "rounded",
		backdrop = 60,
		fullscreen = false,
		preview = {
			default = "bat",
			border = "rounded",
		},
		winopts = { -- builtin previewer window options
			number = true,
			relativenumber = false,
			cursorline = true,
			cursorlineopt = "both",
			cursorcolumn = false,
			signcolumn = "no",
			list = false,
			foldenable = false,
			foldmethod = "manual",
		},
	},
})

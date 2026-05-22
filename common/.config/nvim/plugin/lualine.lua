-- Lualine
vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

require("lualine").setup({
	icons_enabled = true,
	theme = "auto",
})

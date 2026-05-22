vim.pack.add({
	{ src = "https://github.com/norcalli/nvim-colorizer.lua" },
})

require("colorizer").setup({
	"*",
	user_default_options = {
		RGB = true,
		names = false,
		RRGGBB = true,
		RRGGBBAA = true,
		rgb_fn = true,
		hsl_fn = true,
		css = true,
		css_fn = true,

		mode = "foreground",
	},
})

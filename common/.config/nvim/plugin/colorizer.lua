-- FIXME: Deprecated
-- vim.pack.add({
-- 	{ src = "https://github.com/norcalli/nvim-colorizer.lua" },
-- })
--
-- require("colorizer").setup({
-- 	"*",
-- 	user_default_options = {
-- 		RGB = true,
-- 		names = false,
-- 		RRGGBB = true,
-- 		RRGGBBAA = true,
-- 		rgb_fn = true,
-- 		hsl_fn = true,
-- 		css = true,
-- 		css_fn = true,
--
-- 		mode = "foreground",
-- 	},
-- })

-- vim.pack
vim.pack.add({
	{ src = "https://github.com/catgoose/nvim-colorizer.lua" },
})

require("colorizer").setup({
	filetypes = { "*" },
	user_default_options = {
		names = true,
		RGB = true,
		RRGGBB = true,
		css = false,
		mode = "background",
		tailwind = false,
	},
	-- Enable all css color formats
	options = { parsers = {
		css = true,
		tailwind = { enable = true, lsp = true },
	} },
	-- Enable all hex formats
	hex = { default = true },
	json = {
		parsers = { css = true },
	},
	--     markdown = {
	--       parsers = {
	--         hex = { enable = true, rgb = false, rrggbb = true },
	--       },
	--       always_update = true,
	--     },
	display = {
		mode = "background", -- string or list: "background"|"foreground"|"underline"|"virtualtext"
		disable_document_color = false, -- keep vim.lsp.document_color active
	},
})

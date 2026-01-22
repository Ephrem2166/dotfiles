return {
	-- Catppuccin Theme
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		-- color_overrides = {
		--   mocha = {
		--     base = "#000000",
		--   },
		-- },
		flavour = "mocha",
		transparent_background = true,
		float = {
			transparent = true,
			solid = false,
		},

		integrations = {
			aerial = true,
			alpha = true,
			bufferline = false,
			cmp = true,
			dashboard = true,
			flash = true,
			gitsigns = true,
			headlines = true,
			illuminate = true,
			indent_blankline = { enabled = true },
			leap = true,
			lsp_trouble = true,
			mason = true,
			markdown = true,
			mini = {
				enabled = true,
				indentscope_color = "",
			},
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			navic = { enabled = true, custom_bg = "lualine" },
			noice = true,
			notify = true,
			nvimtree = true,
			telescope = false,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
			rainbow_delimiters = true,
			fidget = true,
			snacks = {
				enabled = false,
				indent_scope_color = "",
			},
		},
	},
}

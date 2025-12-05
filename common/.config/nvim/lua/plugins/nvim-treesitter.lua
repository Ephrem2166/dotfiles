return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		indent = {
			enable = true,
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "markdown" },
		},
		folds = {
			enable = true,
		},
		ensure_installed = {
			"bash",
			"c",
			"css",
			"cpp",
			"diff",
			"go",
			"html",
			"java",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"rust",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},
	},
	sync_install = false,
	auto_install = true,
	config = function()
		require("nvim-treesitter").setup({
			renderer = {
				--note on icons:
				--in some terminals, some patched fonts cut off glyphs if not given extra space
				--either add extra space, disable icons, or change font
				icons = {
					show = {
						file = false,
						folder = false,
						folder_arrow = true,
						git = true,
					},
				},
			},
			view = {
				width = 25,
				side = "left",
			},
			sync_root_with_cwd = true, --fix to open cwd with tree
			respect_buf_cwd = true,
			update_cwd = true,
			update_focused_file = {
				enable = true,
				update_cwd = true,
				update_root = true,
			},
		})

		vim.g.nvim_tree_respect_buf_cwd = 1

		-- use g? for bindings help while in tree
	end,
}

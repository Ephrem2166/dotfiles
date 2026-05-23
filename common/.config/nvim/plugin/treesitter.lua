-- Treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
})

require("nvim-treesitter").setup({
	sync_install = false,
	auto_install = true,
	autopairs = { enable = true },
	folds = { enable = true },
	rainbow = { enable = true },
	indent = { enable = true },
	match = { enable = true },

	highlight = {
		enable = true,
		use_languagetree = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymap = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<M-space>",
		},
	},

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

	-- ensure_installed = {
	-- 	"bash",
	-- 	"c",
	-- 	"css",
	-- 	"cpp",
	-- 	"diff",
	-- 	"dockerfile",
	-- 	"go",
	-- 	"git_config",
	-- 	"gitignore",
	-- 	"gitcommit",
	-- 	"html",
	-- 	"java",
	-- 	"javascript",
	-- 	"jsdoc",
	-- 	"json",
	-- 	"jsonc",
	-- 	"lua",
	-- 	"luadoc",
	-- 	"luap",
	-- 	"markdown",
	-- 	"markdown_inline",
	-- 	"php",
	-- 	"printf",
	-- 	"python",
	-- 	"query",
	-- 	"regex",
	-- 	"requirements",
	-- 	"rust",
	-- 	"sql",
	-- 	"toml",
	-- 	"tsx",
	-- 	"typescript",
	-- 	"vim",
	-- 	"vimdoc",
	-- 	"xml",
	-- 	"yaml",
	-- 	"zsh",
	-- },
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "<filetype>" },
	callback = function()
		vim.treesitter.start()
	end,
})

-- auto build on update
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		if name == "nvim-treesitter" then
			vim.cmd("TSUpdate")
		end
	end,
})

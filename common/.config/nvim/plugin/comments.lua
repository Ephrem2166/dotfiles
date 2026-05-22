vim.pack.add({
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/numToStr/Comment.nvim" },

	{ src = "https://github.com/folke/ts-comments.nvim" },
})

require("todo-comments").setup({
	signs = false,
	keywords = {
		FIX = { icon = "" },
		HACK = { icon = "󱠇" },
		TODO = { icon = "" },
		WARN = { icon = "" },
		PERF = { icon = "󱑂" },
		NOTE = { icon = "" },
		TEST = { icon = "󰙨" },
	},
	gui_style = {
		fg = "BOLD",
	},
	highlight = {
		keyword = "fg",
		after = "",
		pattern = {
			[[.*<(KEYWORDS)\s*:]], -- default
			[[.*<(KEYWORDS)\(\S*\):]],
		},
	},
	search = {},
})

require("Comment").setup({

	---Add a space b/w comment and the line
	padding = true,
	---Whether the cursor should stay at its position
	sticky = true,
	---Lines to be ignored while (un)comment
	ignore = nil,
	---LHS of toggle mappings in NORMAL mode
	toggler = {
		---Line-comment toggle keymap
		line = "gcc",
		---Block-comment toggle keymap
		block = "gb",
	},
	-- -LHS of operator-pending mappings in NORMAL and VISUAL mode
	opleader = {
		---Line-comment keymap
		line = "gcc",
		---Block-comment keymap
		block = "gb",
	},
	---LHS of extra mappings
	extra = {
		---Add comment on the line above
		above = "gcO",
		---Add comment on the line below
		below = "gco",
		---Add comment at the end of line
		eol = "gcA",
	},
	---Enable keybindings
	---NOTE: If given `false` then the plugin won't create any mappings
	mappings = {
		---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
		basic = true,
		---Extra mapping; `gco`, `gcO`, `gcA`
		extra = true,
	},
	---Function to call before (un)comment
	pre_hook = nil,
	---Function to call after (un)comment
	post_hook = nil,
})

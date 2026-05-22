vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.nvim" },
})

require("mini.ai").setup()
require("mini.align").setup()
require("mini.comment").setup()
-- require("mini.completion").setup()
require("mini.extra").setup()
require("mini.files").setup()
require("mini.hipatterns").setup()
require("mini.icons").setup()
require("mini.indentscope").setup()
require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.surround").setup()
require("mini.trailspace").setup()
require("mini.move").setup({
	mappings = {
		line_up = "<C-UP>",
		line_down = "<C-DOWN>",
	},
})

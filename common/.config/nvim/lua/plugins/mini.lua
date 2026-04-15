return {
	"nvim-mini/mini.nvim",
	version = false,
	config = function()
		require("mini.ai").setup()
		require("mini.align").setup()
		require("mini.comment").setup()
		-- require("mini.completion").setup()
		require("mini.extra").setup()
		require("mini.files").setup()
		require("mini.hipatterns").setup()
		require("mini.indentscope").setup()
		require("mini.pairs").setup()
		require("mini.pick").setup()
		require("mini.surround").setup()
		require("mini.trailspace").setup()
		require("mini.move").setup({
			mappings = {
				line_up = "<a-UP>",
				line_down = "<a-DOWN>",
			},
		})
	end,
}

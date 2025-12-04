return {
	"mason-org/mason.nvim",
	--enabled = false,
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		ensure_installed = {
			"shellcheck",
		},
	},
	keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
}

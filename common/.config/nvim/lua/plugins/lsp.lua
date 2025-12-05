return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",

		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- Diagnostic signs configuration
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
		vim.diagnostic.config({
			signs = true,
			underline = true,
			update_in_insert = false,
			virtual_text = true,
		})
	end,
}

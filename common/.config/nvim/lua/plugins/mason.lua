return {
	{
		"mason-org/mason.nvim",
		--enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},

		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
					border = "bold",
					width = 0.8,
					height = 0.8,
				},
			})
			require("mason-tool-installer").setup({

				ensure_installed = {
					{ "bash-language-server" },
					{ "lua-language-server" },
					{ "vim-language-server" },
					{ "yaml-language-server" },
					{ "stylua" },
					{ "html-lsp" },
					{ "emmet-ls" },
					{ "css-lsp" },
					{ "pyright" },
					{ "black" },
					{ "autopep8" },
					{ "json-lsp" },
					{ "prettier" },
					{ "biome" },
					--{ "typscript-language-server" },
					---	{ "js-debug-adapter" },
					-- 	{ "eslint-lsp" },
					--	{ "codelldb" },
					--	{ "tailwindcss-language-server" },
					{ "clangd" },
					{ "clang-format" },
				},
				auto_update = false,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 24, -- update or install every 24 hrs
			})
		end,
	},
	-- TOFIX: it throws an error
	-- {
	-- 	"mason-org/mason-lspconfig.nvim",
	-- 	--event = { "BufReadPre", "BufNewFile" },
	-- 	dependencies = {
	-- 		"neovim/nvim-lspconfig",
	-- 	},
	-- 	config = function()
	-- 		require("mason-lspconfig").setup({
	-- 			automatic_enable = true,
	-- 			ensure_installed = { "lua_ls" },
	-- 		})
	-- 		local servers = {
	-- 			-- biome
	-- 			biome = {
	-- 				filetypes = {
	-- 					"javascript",
	-- 					"javascriptreact",
	-- 					"javascript.jsx",
	-- 					"typescript",
	-- 					"typescriptreact",
	-- 					"typescript.tsx",
	-- 				},
	-- 			},
	-- 			-- emmet_ls
	-- 			emmet_ls = {
	-- 				filetypes = {
	--
	-- 					"html",
	-- 					"htmx",
	-- 					"typescriptreact",
	-- 					"javascriptreact",
	-- 				},
	-- 			},
	-- 			clangd = {},
	-- 			pyright = {},
	-- 			html = {},
	-- 		}
	-- 		-- enable lsps
	-- 		for server, config in pairs(servers) do
	-- 			vim.lsp.config(server, config)
	-- 			vim.lsp.enable(server)
	-- 		end
	-- 	end,
	-- },
}

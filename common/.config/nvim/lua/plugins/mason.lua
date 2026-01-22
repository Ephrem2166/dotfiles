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
				vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>"),
			})
			require("mason-tool-installer").setup({

				ensure_installed = {
					{ "bash-language-server" },
					{ "lua-language-server" },
					{ "vim-language-server" },
					{ "yaml-language-server" },
					{ "emmet-language-server" }, -- css/html snippets
					{ "stylua" },
					{ "html-lsp" },
					{ "emmet-ls" },
					{ "css-lsp" },
					-- { "pyright" },
					{ "basedpyright" }, -- python lsp (pyright fork)
					{ "ruff" }, -- python linter & formatter
					{ "black" },
					{ "autopep8" },
					{ "json-lsp" },
					{ "prettier" },
					{ "biome" },
					{ "isort" },
					{ "jq" },
					{ "shfmt" },
					{ "tombi" },
					{ "harper-ls" }, -- natural language linter
					{ "ltex-ls-plus" }, -- natural language linter (LanguageTool, ltex
					--{ "typscript-language-server" },

					---	{ "js-debug-adapter" },
					-- 	{ "eslint-lsp" },
					--	{ "codelldb" },
					--	{ "tailwindcss-language-server" },
					{ "dockerfile-language-server" },
					{ "eslint-lsp" },
					{ "markdownlint" },
					{ "rumdl" }, -- modern markdownlint
					{ "clangd" },
					{ "prettier" },
					{ "prettierd" },
					{ "python-lsp-server" },
					{ "rust-analyzer" },
					{ "shfmt" }, -- shell formatter (via bashls)
					{ "shellcheck" },
					{ "clang-format" },
				},
				auto_update = false,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 24, -- update or install every 24 hrs
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		opt = {
			automatic_enable = true,
			ensure_installed = {
				"dockerls",
				"eslint",
				"jsonls",
				"marksman",
				"rust_analyzer",
				"vimls",
				"yamlls",
				"basedpyright",
				"lua_ls",
			},
		},
	},
}

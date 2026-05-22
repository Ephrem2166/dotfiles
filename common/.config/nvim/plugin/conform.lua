-- Conform
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
	formatters_by_ft = {
		bash = { "shfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		css = { "prettierd", "prettier" },
		--	html = {  "prettierd", "prettier" },
		lua = { "stylua" },
		-- json = { "biome" },
		-- jsoc = { "biome" },
		--
		javascript = { "prettierd", "prettier" },
		javascriptreact = { "prettierd", "prettier" },
		json = { "prettierd", "prettier" },
		-- jsonc = { "prettierd", "prettier" },
		-- markdown = { "prettierd", "prettier", "injected" },
		python = { "isort", "ruff" },
		-- rasi = { "prettierd", "prettier" },
		sh = { "shfmt" },
		-- typescript = { "prettierd", "prettier" },
		-- typescriptreact = { "prettierd", "prettier" },

		yaml = { "prettierd", "prettier" },
		yml = { "prettierd", "prettier" },

		-- Apply on all filetype

		-- ["*"] = { "codespell" },
		-- trim whitespace
		["_"] = { "trim_whitespace", "trim_newlines" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	format_after_save = {
		lsp_format = "fallback",
	},
	formatters = {
		shfmt = {
			prepend_args = { "-i", "2" },
		},
	},
	notify_on_error = true,
	notify_no_foratters = true,

	-- format on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function(args)
			require("conform").format({ bufnr = args.buf })
		end,
	}),
})

vim.keymap.set("n", "=", function()
	require("conform").format({ async = true, lsp_fallback = true }, function(err)
		if not err then
			if vim.startswith(vim.api.nvim_get_mode().mode:lower(), "v") then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
			end
		end
	end)
end, { desc = "Format buffer" })

vim.keymap.set("n", "<leader>cf", require("conform").format, { desc = "Code format" })

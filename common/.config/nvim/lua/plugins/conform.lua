return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			lua = { "stylua" },
			javascript = { "prettierd", "prettier" },
			python = { "isort", "black" },
			-- Apply on all filetype

			-- ["*"] = { "codespell" },
			-- trim whitespace
			["_"] = { "trim_whitespace" },
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
	},
}

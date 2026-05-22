vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-lint" },
})

local linter = require("lint")

linter.linters_by_ft = {
	-- lua = { "luacheck" },

	bash = { "shellcheck" },
	cpp = { "cpplint" },
	--json = { "jsonlint" },
	go = { "golangcilint" },
	lua = { "luac" },
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	-- markdown = { "markdownlint" },
	nix = { "nix" },
	python = { "pylint", "ruff" },
	sh = { "shellcheck" },
	toml = { "tombi" },

	-- yaml = { "yamllint" },
	zsh = { "zsh" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufWinEnter" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

vim.keymap.set("n", "<leader>ll", function()
	linter.try_lint()
end, { desc = "Trigger linting for current file" })

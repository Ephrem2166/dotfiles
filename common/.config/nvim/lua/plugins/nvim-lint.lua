return {
	"mfussenegger/nvim-lint",
	config = function()
		local L = require("lint")

		-- local cpp_check = L.linters.cppcheck
		-- table.insert(cpp_check.args, "--enable=information,warning")
		-- table.insert(cpp_check.args, "--disable=warning")
		-- local lua_check = L.linters.luacheck
		-- table.insert(lua_check.args, 1, "--enable=information,warning")

		local shellcheck = L.linters.shellcheck
		table.insert(shellcheck.args, "-x")

		L.linters_by_ft = {
			-- lua = { "luacheck" },

			bash = { "shellcheck" },
			cpp = { "cpplint" },
			json = { "jsonlint" },
			go = { "golangcilint" },
			lua = { "luac" },
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			markdown = { "markdownlint" },
			nix = { "nix" },
			python = { "pylint", "ruff" },
			sh = { "shellcheck" },
			svelte = { "eslint_d" },
			typescript = { "eslint_d" },
			toml = { "tombi" },
			typescriptreact = { "eslint_d" },

			yaml = { "yamllint" },
			zsh = { "zsh" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufWinEnter" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}

-- LSP
vim.pack.add({
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
})

-- vim.lsp.config("*", {
-- 	capabilities = vim.lsp.protocol.make_client_capabilities(),
-- })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("<leader>rn", vim.lsp.buf.rename, "re[n]ame symbol")

		map("<leader>ca", vim.lsp.buf.code_action, "code [a]ction")

		map("<leader>co", function()
			vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
		end, "code [o]rganize imports")

		map("K", vim.lsp.buf.hover, "Hover Documentation")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				callback = function(event2)
					group =
						vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, "Toggle inlay [h]ints")
		end
	end,
})

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

local servers = {
	"bashls", -- Bash
	"clangd", -- C/C++
	-- "gopls", -- Golang
	"html-lsp",
	"lua_ls", -- Lua
	"pyright", -- Python
	"ruff",
	-- Web Dev LSPs
	"html", -- HTML
	"emmet_ls", -- HTML
	"cssls", -- CSS
	"jsonls",
	-- "tailwindcss", -- Tailwind
	-- "ts_ls", -- Typescript/javascript
	-- "eslint", -- Typescript/javascript
	"marksman",
	"taplo", -- Toml
	"tombi",
	"yamlls",
}

vim.lsp.enable(servers)

-- vim.lsp.config("*", {
-- 	capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
-- 	root_markers = { ".git" },
-- })

vim.lsp.config("*", {
	-- Fetches blink's capabilities
	capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
	root_markers = { ".git" },
})

vim.keymap.set("n", "<leader>td", function()
	local is_enabled = vim.diagnostic.is_enabled()
	vim.diagnostic.enable(not is_enabled)
end, { desc = "Toggle Diagnostics" })

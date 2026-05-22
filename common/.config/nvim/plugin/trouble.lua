vim.pack.add({
	{ src = "https://github.com/folke/trouble.nvim" },
})

require("trouble").setup({
	auto_jump = true, -- auto jump to the item when there's only one
	focus = true, -- Focus the window when opened
	auto_preview = false, -- automatically open preview when on an item
	auto_refresh = true, -- auto refresh when open
	preview = {
		type = "main",
		-- Set to false, if you want the preview to always be a real loaded buffer.
		scratch = true,
	},
	win = {
		border = vim.g.border_style,
		size = 0.38, -- This weird size makes sense with the resize autocmd
	},
})

local map = function(keys, func, desc)
	vim.keymap.set("n", keys, func, { silent = true, desc = "Trouble: " .. desc })
end

map("<leader>cx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics")
map("<leader>cX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics")
map("<leader>cs", "<cmd>Trouble lsp toggle<cr>", "LSP Definitions / references / ...")
map("<leader>cL", "<cmd>Trouble loclist toggle<cr>", "Location List")
map("<leader>cQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List")
map("<leader>cS", "<cmd>Trouble symbols toggle<cr>", "Document Symbols")

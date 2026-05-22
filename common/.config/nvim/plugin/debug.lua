vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mfussenegger/nvim-dap-python",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rcarriga/nvim-dap-ui",
})

local dap = require("dap")
local dapui = require("dapui")

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>cb", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>cB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Breakpoint" })
-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup({
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	controls = {
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			step_back = "b",
			run_last = "▶▶",
			terminate = "⏹",
			disconnect = "⏏",
		},
	},
})

-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

require("mason-nvim-dap").setup({
	automatic_setup = true,

	-- You can provide additional configuration to the handlers,
	-- see mason-nvim-dap README for more information
	handlers = {},

	-- You'll need to check that you have the required things installed
	-- online, please don't ask me how to install them :)
	ensure_installed = {
		-- Update this to ensure that you have the debuggers for the langs you want
		"python",
	},
})
require("dap-python").setup("python")

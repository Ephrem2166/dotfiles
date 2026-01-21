return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "nvim-mini/mini.icons" },
		---@module "fzf-lua"
		---@type fzf-lua.Config|{}
		---@diagnostics disable: missing-fields
		opts = {},
		---@diagnostics enable: missing-fields
		keys = {
			{
				"<leader>/c",
				function()
					require("fzf-lua").commands()
				end,
				desc = "search commands",
			},
			{
				"<leader>/C",
				function()
					require("fzf-lua").command_history()
				end,
				desc = "search command history",
			},
			{
				"<leader>/f",
				function()
					require("fzf-lua").files()
				end,
				desc = "search old files",
			},
			{
				"<leader>/h",
				function()
					require("fzf-lua").highlights()
				end,
				desc = "search highlights",
			},
			{
				"<leader>/M",
				function()
					require("fzf-lua").marks()
				end,
				desc = "search marks",
			},
			{
				"<leader>/k",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "search keymaps",
			},
			{
				"<leader>//",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "live grep",
			},
			{
				"<leader>/gf",
				function()
					require("fzf-lua").git_files()
				end,
				desc = "search git file names",
			},
			{
				"<leader>/gb",
				function()
					require("fzf-lua").git_branches()
				end,
				desc = "search git branches",
			},
			{
				"<leader>/gc",
				function()
					require("fzf-lua").git_commits()
				end,
				desc = "search git commits",
			},
			{
				"<leader>/gC",
				function()
					require("fzf-lua").git_bcommits()
				end,
				desc = "search git buffer commits",
			},
			{
				"<leader>/r",
				function()
					require("fzf-lua").resume()
				end,
				desc = "resume fzf",
			},
		},
		config = function()
			require("fzf-lua").setup({
				winopts = {
					height = 0.85,
					width = 0.80,
					row = 0.35,
					col = 0.50,
					border = "rounded",
					backdrop = 60,
					fullscreen = false,
					preview = {
						default = "bat",
						border = "rounded",
					},
					winopts = { -- builtin previewer window options
						number = true,
						relativenumber = false,
						cursorline = true,
						cursorlineopt = "both",
						cursorcolumn = false,
						signcolumn = "no",
						list = false,
						foldenable = false,
						foldmethod = "manual",
					},
				},
			})
		end,
	},
}

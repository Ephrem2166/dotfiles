-- Blink
vim.pack.add({
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = vim.version.range("^1"),
	},
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
})

require("blink.cmp").setup({
	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	--
	-- All presets have the following mappings:
	-- C-space: Open menu or open docs if already open:wq
	-- C-n/C-p or Up/Down: Select next/previous item
	-- C-e: Hide menu
	-- C-k: Toggle signature help (if signature.enabled = true)
	--
	-- See :h blink-cmp-config-keymap for defining your own keymap
	keymap = {
		preset = "none",
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Esc>"] = { "hide", "fallback" },
		["<PageUp>"] = { "scroll_documentation_up", "fallback" },
		["<PageDown>"] = { "scroll_documentation_down", "fallback" },
	},
	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},
	cmdline = {
		enabled = true,
		sources = function()
			local type = vim.fn.getcmdtype()
			if type == "/" or type == "?" then
				return { "buffer" }
			end
			if type == ":" then
				return { "cmdline" }
			end
			return {}
		end,
		completion = {
			list = { selection = { auto_insert = false, preselect = false } },
			menu = { auto_show = true },
			ghost_text = { enabled = true },
		},

		keymap = {
			preset = "inherit",
		},
	},

	-- (Default) Only show the documentation popup when manually triggered
	completion = {

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
			treesitter_highlighting = false,
			window = {
				border = vim.g.border_style,
				min_width = 40,
				direction_priority = {
					menu_north = { "e", "w" },
					menu_south = { "e", "w" },
				},
			},
		},
		menu = {
			auto_show = true,
			border = vim.g.border_style,
			min_width = 40,
			max_height = 30,
			scrolloff = 0,
			scrollbar = false,
			-- direction_priority = { "n", "s" },
			-- draw = { treesitter = { "lsp" } },

			draw = {
				align_to = "kind_icon",
				padding = { 0, 1 },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
			},
		},
		keyword = {
			range = "prefix",
		},
		trigger = {
			-- prefetch_on_insert = true,
			show_on_keyword = true,
			show_on_accept_on_trigger_character = true,
			show_on_insert_on_trigger_character = true,
			show_on_trigger_character = true,
			show_on_blocked_trigger_characters = { " ", "\n", "\t" },
		},
		list = { selection = { preselect = false, auto_insert = true } },
		ghost_text = {
			enabled = true,
		},
	},
	-- fuzzy = {
	-- 	sorts = {
	-- 		"exact",
	-- 		"score",
	-- 		"show_text",
	-- 	},
	-- },

	fuzzy = {
		implementation = "lua",
		prebuilt_binaries = { download = false },
	},
	snippets = { preset = "luasnip" },
	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },

		providers = {
			buffer = {
				name = "Buffer",
				enabled = true,
				max_items = 3,
				module = "blink.cmp.sources.buffer",
				min_keyword_length = 2,
				score_offset = 65, -- the higher the number, the higher the priority
				transform_items = function(a, items)
					local keyword = a.get_keyword()
					local correct, case
					if keyword:match("^%l") then
						correct = "^%u%l+$"
						case = string.lower
					elseif keyword:match("^%u") then
						correct = "^%l+$"
						case = string.upper
					else
						return items
					end

					-- avoid duplicates from the corrections
					local seen = {}
					local out = {}
					for _, item in ipairs(items) do
						local raw = item.insertText
						if raw and raw:match(correct) then
							local text = case(raw:sub(1, 1)) .. raw:sub(2)
							item.insertText = text
							item.label = text
						end
						if not seen[item.insertText] then
							seen[item.insertText] = true
							table.insert(out, item)
						end
					end
					return out
				end,
			},
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
				fallbacks = { "lsp" },
			},

			lsp = {
				max_items = 100,
				name = "lsp",
				enabled = true,
				-- module = "blink.cmp.sources.lsp",
				-- score_offset = 95,
			},
			path = {
				name = "Path",
				-- module = "blink.cmp.sources.path",
				score_offset = 70,
				min_keyword_length = 2,
				fallbacks = { "snippets", "buffer" },
				opts = {
					trailing_slash = false,
					label_trailing_slash = true,
					get_cwd = function(context)
						return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
					end,
					show_hidden_files_by_default = true,
				},
			},
			snippets = {
				name = "Snippets",
				module = "blink.cmp.sources.snippets",
				min_keyword_length = 2,
				score_offset = 0,
			},
			-- datword = {
			-- 	name = "Word",
			-- 	module = "blink-cmp-dat-word",
			-- 	opts = {
			-- 		paths = {
			-- 			-- "path_to_your_words.txt", -- add your owned word files before dictionary.
			-- 			"/usr/share/dict/words", -- This file is included by default on Linux/macOS.
			-- 		},
			-- 	},
			-- },
		},
	},

	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	--
	-- See the fuzzy documentation for more information
	-- fuzzy = { implementation = "prefer_rust_with_warning" },
})

require("luasnip").config.set_config({
	enable_autosnippets = true,
	history = true,
	updateevents = "TextChanged,TextChangedI",
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip").filetype_extend("all", { "loremipsum" })
-- lua format
require("luasnip.loaders.from_lua").load()

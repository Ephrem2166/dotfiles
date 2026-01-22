return {
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				-- preset = "default",

				preset = "none",
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},
			cmdline = {
				completion = {
					list = { selection = { auto_insert = false, preselect = true } },
					menu = { auto_show = true },
					ghost_text = { enabled = false },
				}
				keymap = {
					preset = "inherit",
				},
			},
			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				documentation = {
					auto_show = true,
				},
				menu = {
					border = "bold",
					direction_priority = { "n", "s" },
					draw = { treesitter = { "lsp" } },
					scrollbar = false,
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
				list = { selection = { preselect = true, auto_insert = true } },
			},
			fuzzy = {
				sorts = {
					"exact",
					"score",
					"show_text",
				},
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
					},
					lsp = {
						name = "lsp",
						enabled = true,
						module = "blink.cmp.sources.lsp",
						score_offset = 95,
					},
					path = {
						name = "Path",
						module = "blink.cmp.sources.path",
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
						score_offset = 85,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = "InsertEnter",
		postinstall = "make install_jsregexp",
		config = function()
			local luasnip = require("luasnip")
			luasnip.setup({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
			})
			-- add vscode exported completions
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
	},
}

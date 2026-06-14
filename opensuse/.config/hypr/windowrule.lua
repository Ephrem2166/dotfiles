hl.window_rule({

	match = {
		class = "foot*",
	},
	tag = "+terminal",
})
hl.window_rule({
	match = {
		class = "Alacritty*",
	},
	tag = "+terminal",
})
hl.window_rule({
	match = {
		class = "firefox*",
	},
	tag = "+browsers",
})
hl.window_rule({
	match = {
		class = "librewolf*",
	},
	tag = "+browsers",
})
hl.window_rule({
	match = {
		class = "[b|Brave]*",
	},
	tag = "+browsers",
})

hl.window_rule({
	match = {
		class = "org.kde.dolphin",
	},
	workspace = "2",
})

hl.window_rule({
	match = {
		class = "emacs",
	},
	workspace = "7",
})
hl.window_rule({
	match = {
		class = "mpv",
	},
	workspace = "4",
})
hl.window_rule({
	match = {
		class = "*telegram*",
	},
	workspace = "5",
})
hl.window_rule({
	match = {
		class = "org.kde.okular",
	},
	workspace = "8",
})
hl.window_rule({
	match = {
		tag = "terminal",
	},
	workspace = "1",
})

hl.window_rule({
	match = {
		tag = "browsers",
	},
	workspace = "3",
})

-- Ignore maximize requests from all apps. You'll probably like this.
local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

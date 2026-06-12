hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60",
	position = auto,
	scale = 1,
})

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 3,
		--	no_border_on_floating = false,
		border_size = 0,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = false,
		--extend_border_grab_area = 15,
		allow_tearing = false,

		-- dwindle or master
		layout = dwindle,
	},
	decoration = {
		rounding = 0,
		rounding_power = 4,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
	animations = {
		enabled = false,
	},
})

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	master = {

		new_status = slave,
	},
})

hl.config({

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
})

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		mouse_refocus = true,
		focus_on_close = 0,

		numlock_by_default = false,

		repeat_rate = 25,
		repeat_delay = 600,

		sensitivity = 0.0, -- -1.0 - 1.0, 0 means no modification.,
	},
})

local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "dolphin"
local power = "$HOME/.config/hypr/scripts/powermenu"
local lockscreen = "$HOME/.config/hypr/scripts/lockscreen"
local launch = "$HOME/.config/hypr/scripts/launch.sh"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(
	mainMod .. "+ D",
	hl.dsp.exec_cmd("command -v pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window")
)

hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(power))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(power))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.exec_cmd(lockscreen))
hl.bind(mainMod .. " + SHIFT + r", hl.dsp.exec_cmd(launch))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "e-1" }))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("mpd")
	hl.exec_cmd("hypridle & hyprpaper")
	hl.exec_cmd("/usr/lib/kdeconnectd")
	hl.exec_cmd("swaync")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("gammastep")
	hl.exec_cmd("gammastep-indicator")
	hl.exec_cmd("udiskie --no-automount --smart-tray")
	hl.exec_cmd("wl-paste --type text --watch cliphist store ")
	hl.exec_cmd("wl-paste --type image --watch cliphist store #")
	hl.exec_cmd(
		"waybar -c /home/ephrem/.config/waybar/hyprconfig.jsonc -s /home/ephrem/.config/waybar/style.css -l off"
	)
	hl.exec_cmd("pgrep emacs | xargs kill 1> /dev/null")
	hl.exec_cmd("emacs --daemon")
	hl.exec_cmd("/usr/libexec/polkit-kde-authentication-agent-1")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP")
end)

hl.env("XCURSOR_SIZE", "24")

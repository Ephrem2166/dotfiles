local wezterm = require("wezterm")
local config = wezterm.config_builder()

config = {
    -- Check colorscheme at wezterm website https://wezfurlong.org/wezterm/colorschemes/index.html
    color_scheme = "nord",
    -- Tabs are enabled by default
    enable_tab_bar = false,
    -- Disable wayland support, Somewhat broken on hyprland, Works with -git
    enable_wayland = false,
    font = wezterm.font("Berkeley Nerd Font"),
    font_size = 11.0,
    line_height = 1.2,
    automatically_reload_config = true,
    enable_scroll_bar = false,
    front_end = "WebGpu",
    warn_about_missing_glyphs = false,
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,

    -- Blur and opacity
    macos_window_background_blur = 40,
    window_background_opacity = 1.0,
    -- Remove the window decorations
    window_decorations = "RESIZE",
    keys = {
        -- {
        -- 	key = "f",
        -- 	mods = "CTRL",
        -- 	action = wezterm.action.ToggleFullScreen,
        -- },
    },
    mouse_bindings = {
        -- Ctrl-click will open the link under the mouse cursor
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    },
}
return config

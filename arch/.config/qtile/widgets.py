import os
from libqtile import qtile, widget, bar
import colors

color = colors.nord
widget_defaults = dict(
    font="Berkeley Nerd Font Bold",
    fontsize=32,
    padding=10,

    background=color[0],
    foreground=color[2],
)
extension_defaults = widget_defaults.copy()


def check_bluetooth_status():
    try:
        result = subprocess.run(
            ["bluetoothctl", "show"], capture_output=True, text=True, timeout=1
        )
        if "Powered: yes" in result.stdout:
            return "ON"
        else:
            return "OFF"
    except:
        return "N/A"


def create_separator():
    return widget.TextBox(
        text="|",
        padding=8,
        # fontsize=14
    )


my_widgets = [
    # widget.CurrentLayoutIcon(scale=0.5, **widget_defaults),
    widget.GroupBox(
        margin_x=4,
        margin_y=5,
        padding_x=5,
        padding_y=5,
        spacing=10,
        center_aligned=True,
        disable_drag=True,
        rounded=False,
        use_mouse_wheel=True,
        highlight_method="line",
        background=color[0],
        foreground=color[2],
        active=color[2],
        inactive=color[2],
        highlight_color=color[4],
        hide_unused=True,
        border_width=3,
    ),
    widget.Spacer(
        length=bar.STRETCH,
    ),
    widget.Clock(
        padding=10,
        format="  %a, %b %d %H:%M",
        foreground=color[2],
        background=color[0],
    ),
    # widget.Prompt(),
    # widget.WindowName(
    #     margin_x=4,
    #     margin_y=2,
    #     padding_x=0,
    #     padding_y=5,
    #     spacing=10,
    # ),
    # widget.Chord(
    #     chords_colors={
    #         "launch": ("#ff0000", "#ffffff"),
    #     },
    #     name_transform=lambda name: name.upper(),
    # ),
    # widget.TextBox("default config", name="default"),
    # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
    # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
    # widget.StatusNotifier(),
    # widget.Mpd2(
    #     color_progress=color[0],
    # play_states="{'pause': '⏸', 'play': '▶', 'stop': '■'}",
    #    idle_format="{play_status} {idle_message} {consume}",
    #    status_format="{artist} - {title} {play_status}",
    #   no_connection="No Connection",
    #    # max_chars=0,
    #    foreground=color[2],
    #    background=color[0],
    # ),
    widget.Spacer(
        length=bar.STRETCH,
    ),

    widget.Volume(
        fmt="󰕾 {}",
        mute_command="pamixer -t",
        volume_up_command="pamixer -i 2",
        volume_down_command="pamixer -d 2",
        get_volume_command="pamixer --get-volume-human",
        check_mute_command="pamixer --get-mute",
        check_mute_string="true",
        foreground=color[2],
        background=color[0],
        padding=10,

    ),
    widget.Spacer(length=4),

    widget.Backlight(
        backlight_name=os.listdir("/sys/class/backlight")[-1],
        step=10,
        update_interval=None,
        padding=10,
        format="  {percent:2.0%}",
        foreground=color[2],
        background=color[0],
        change_command=None,
    ),
    widget.Spacer(length=4),
    widget.Battery(
        format="󰁹 {percent:2.0%}",
        charge_char="",
        discharge_char="",
        empty_char="",
        full_char=" ",
        full_short_text=" ",
        padding=10,
        update_interval=5,
        # show_short_text=False,
        background=color[0],
        foreground=color[2],
    ),
    widget.Spacer(length=4),
    widget.DF(
        padding=10,
        foreground=color[2],
        background=color[0],
        visible_on_warn=False,
        # format="{p} {uf}{m} ({r:.0f}%)",
        update_interval=60,
        format='{r:.0f}%',
        partition='/',
        fmt="🖴 {}",
    ),
    widget.Spacer(length=4),
    widget.CPU(
        padding=10,
        format="  {freq_current} GHz {load_percent}%",

        foreground=color[2],
        background=color[0],
    ),
    widget.Spacer(length=4),
    widget.ThermalSensor(
        padding=10,
        update_interval=1,
        format="󰔐 {temp:.1f}{unit}",
        # tag_sensor="Tctl",
        foreground=color[2],
        background=color[0],
    ),
    widget.Spacer(length=4),
    widget.Memory(
        padding=10,
        format="󰈀 {MemUsed:.0f}M",
        background=color[0],
        foreground=color[2],
    ),
    # widget.Net(
    #    format=" {down:6.2f}{down_suffix:<2} {up:6.2f}{up_suffix:<2} ",
    # ),
    widget.Spacer(length=4),
    widget.Wlan(
        foreground=color[2],
        background=color[0],
        padding=10,
        format="  {essid} {percent:2.0%}",
        disconnected_message="󰖪",
        interface="wlp59s0",
        update_interval=5,
    ),
    widget.Spacer(length=4),
    #  widget.GenPollText(
    #                    func=lambda: check_bluetooth_status(),
    #                   update_interval=5,
    #                    fmt='󰂯:{}',
    #                    mouse_callbacks={
    #                        'Button1': lazy.spawn('blueman-applet'),  # Left click
    #                        'Button3': lazy.spawn('pkill blueman'),                    }
    #                ),
    # widget.TextBox(
    #     foreground=color[2],
    #     background=color[0],
    #     padding=10,
    #     text=" ",
    #     fontsize=20,
    #     mouse_callbacks={
    #         "Button1": lambda: qtile.cmd_spawn(
    #             "~/.config/qtile/powermenu.sh"
    #         )
    #     },
    # ),
    # widget.Notify(),
    widget.CurrentLayout(
        # format="{}",
        custom_icon_paths=[os.path.expanduser("./icons/")],
        padding=10,
        scale=0.5,
        background=color[0],
    ),
    # widget.Systray(
    #     padding=4,
    #     hide_crash=True,
    # ),
    # widget.Systray(),
    # widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
    # widget.QuickExit(),
    # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
    # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
    # By default we handle these events delayed to already improve performance, however your system might still be struggling
    # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
    # x11_drag_polling_rate = 60,
]

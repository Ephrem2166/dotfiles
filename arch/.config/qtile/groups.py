from libqtile.config import Match, Key, Group
from libqtile.lazy import lazy
from keys import keys, mod

# groups = []
# group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

# Uncomment only one of the following lines
# group_labels = ["", "", "👁", "", "", "", "✀", "꩜", "", "⎙"]
# group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]


groups = [Group(i) for i in "1234567890"]
groups = [
    Group(
        "1",
        label=" ",
        matches=[
            Match(wm_class="kitty"),
            Match(wm_class="alacritty"),
            Match(wm_class="ghostty"),
        ],
        layout="bsp",
    ),
    Group("2", label=" ", matches=[Match(wm_class="dolphin")], layout="bsp"),
    Group("3", label="󰈹 ", matches=[Match(wm_class="firefox")], layout="bsp"),
    Group("4", label=" ", matches=[Match(wm_class="mpv")], layout="bsp"),
    Group("5", label=" ", matches=[Match(wm_class="telegram")], layout="bsp"),
    Group(
        "6",
        label=" ",
        matches=[
            Match(wm_class="soffice"),
            Match(wm_class="libreoffice-startcenter"),
            Match(wm_class="libreoffice-writer"),
            Match(wm_class="libreoffice-base"),
            Match(wm_class="libreoffice-calc"),
            Match(wm_class="libreoffice-draw"),
            Match(wm_class="libreoffice-impress"),
            Match(wm_class="libreoffice-math"),
        ],
        layout="bsp",
    ),
    Group("7", label=" ", matches=[Match(wm_class="emacs")], layout="max"),
    Group("8", label="󰈦 ", matches=[Match(wm_class="okular")], layout="bsp"),
    Group("9", label="", matches=[Match(wm_class="vlc")], layout="columns"),
    Group("0", label=" ", layout="bsp"),
]


for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

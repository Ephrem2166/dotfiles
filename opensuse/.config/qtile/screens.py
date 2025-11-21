import os
import subprocess
from libqtile import qtile, widget
from libqtile.config import Screen
import colors
from libqtile import bar
from libqtile.lazy import lazy
from widgets import my_widgets



my_wallpaper = "~/Pictures/berserk.png"
color = colors.nord


def widget_def(widgets):
    return bar.Bar(widgets, 26,
                   margin=[0, 5, 0, 5],
                   border_width=0,
                   background=color[0]
                   )
screens = [
    Screen(
        top=widget_def(my_widgets),
        wallpaper=my_wallpaper,
        wallpaper_mode="fill",
    ),
]

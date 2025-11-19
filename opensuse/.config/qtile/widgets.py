from libqtile import qtile
from libqtile import widget
import colors
color = colors.nord
widget_defaults = dict(
    font="Berkeley Nerd Font",
    fontsize=12,
    padding=3,
    background=color[0],
    foreground=color[2],
)
extension_defaults = widget_defaults.copy()

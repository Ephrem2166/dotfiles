from libqtile import qtile
from libqtile import widget
import colors

color = colors.nord
widget_defaults = dict(
    font="Berkeley Nerd Font Bold",
    fontsize=22,
    padding=1,
    background=color[0],
    foreground=color[2],
)
extension_defaults = widget_defaults.copy()

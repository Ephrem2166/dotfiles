#!/bin/sh

# Read file path into variable
read -r wallpaper<~/.config/hypr/wallpaper/city.jpg

if pgrep swaybg; then
	pkill swaybg
fi
#swaybg -m fill -i "$wallpaper"
hyprctl hyprpaper preload "$wallpaper"
hyprctl hyprpaper wallpaper " , $wallpaper"
hyprctl hyprpaper unload unused


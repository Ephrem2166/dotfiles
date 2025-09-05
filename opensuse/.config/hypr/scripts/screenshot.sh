#!/bin/bash

case $1 in
	selected-region)
		# Take a screenshot of the selected region
		grim -t jpeg -g "$(slurp)" ~/Pictures/Screenshots/"$(date +%Y-%m-%d_%H-%m-%s)".jpg
		;;
	save-to-clipboard)
		# Take a screenshot and save it to the clipboard
		grim -g "$(slurp -d)" - | wl-copy
		;;
	focused-window)
		# Take a screenshot of the focused window
		pos=$(hyprctl -j activewindow |  grep 'at' | tr -dc '0-9 ')
		xpos=$(echo "$pos" | awk '{ print $1 }')
		xpos=$((xpos-2))
		ypos=$(echo "$pos" | awk '{ print $2 }')
		ypos=$((ypos-2))
		size=$(hyprctl -j activewindow |  grep 'size' | tr -dc '0-9 ')
		xsize=$(echo "$size" | awk '{ print $1 }')
		ysize=$(echo "$size" | awk '{ print $2 }')
		xsize=$((xsize+4)) # Value added is 2 times the border width
		ysize=$((ysize+4)) # Value added is 2 times the border width
		grim -g "$xpos"",""$ypos $xsize""x""$ysize" -t jpeg ~/Pictures/Screenshots/"$(date +%Y-%m-%d_%H-%m-%s)".jpg
		;;
		*)
		# Take a screenshot of the currently focused output and save it into screenshots
		output="$(hyprctl monitors | grep -B 12 'focused: yes' | grep 'Monitor' | awk '{ print $2 }')"
		grim -o "$output" -t jpeg ~/Pictures/Screenshots/"$(date +%Y-%m-%d_%H-%m-%s)".jpg
		;;
esac

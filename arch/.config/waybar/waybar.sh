#!/usr/bin/env bash
#
# Define a unique config path (if needed)
CONFIG_PATH="$HOME/.config/waybar/swayconfig.jsonc"

# Find and kill only the Waybar instance using that config
# Assumes the config path appears in the process arguments
pkill -f "waybar.*$CONFIG_PATH"

# Wait briefly to ensure the process is terminated
sleep 1

# Relaunch the specific Waybar instance
waybar -c "$CONFIG_PATH" -s "$HOME/.config/waybar/style.css" 2>&1 | tee -a /tmp/waybar-custom.log &
disown

echo "Waybar reloaded with config: $CONFIG_PATH"

#!/bin/bash

killall -SIGUSR2 waybar &
notify-send "Waybar Reloaded"

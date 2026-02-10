#!/usr/bin/env bash
set -euo pipefail

DIR="FILE LOCATION OF WALLPAPERS"
MON1="DP-2"
MON2="DP-1"

img="$(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 | shuf -z -n 1 | tr -d '\0')"

hyprctl hyprpaper preload "$img" >/dev/null
hyprctl hyprpaper wallpaper "$MON1,$img" >/dev/null
hyprctl hyprpaper wallpaper "$MON2,$img" >/dev/null

#!/usr/bin/env bash
set -uo pipefail

DIR="FILE LOCATION OF WALLPAPERS"
MON1="DP-2"
MON2="DP-1"

mapfile -d '' picks < <(
  find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 \
    | shuf -z -n 2
)

img1="${picks[0]:-}"
img2="${picks[1]:-$img1}"

[[ -z "$img1" ]] && exit 0

hyprctl hyprpaper preload "$img1" >/dev/null || true
hyprctl hyprpaper preload "$img2" >/dev/null || true
hyprctl hyprpaper wallpaper "$MON1,$img1" >/dev/null || true
hyprctl hyprpaper wallpaper "$MON2,$img2" >/dev/null || true
hyprctl hyprpaper unload unused >/dev/null || true

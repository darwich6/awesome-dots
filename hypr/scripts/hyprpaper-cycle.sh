#!/usr/bin/env bash
set -uo pipefail

DIR="FILE LOCATION OF WALLPAPERS"
INTERVAL=900
MON1="DP-2"
MON2="DP-1"

until hyprctl hyprpaper listloaded &>/dev/null; do
  sleep 0.5
done

while true; do
  mapfile -d '' picks < <(
    find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 \
      | shuf -z -n 2
  )

  img1="${picks[0]:-}"
  img2="${picks[1]:-$img1}"

  if [[ -n "$img1" ]]; then
    hyprctl hyprpaper preload "$img1" >/dev/null || true
    hyprctl hyprpaper preload "$img2" >/dev/null || true
    hyprctl hyprpaper wallpaper "$MON1,$img1" >/dev/null || true
    hyprctl hyprpaper wallpaper "$MON2,$img2" >/dev/null || true
    hyprctl hyprpaper unload unused >/dev/null || true
  fi

  sleep "$INTERVAL"
done

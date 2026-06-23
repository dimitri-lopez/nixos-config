#!/bin/sh
SRC="$HOME/.config/driftwm/config.toml"
DST="$HOME/.dotfiles/modules/driftwm/config.toml"
sed "s|/nix/store/[^/]*-polkit-gnome-[^/]*|@polkit_gnome@|g" "$SRC" > "$DST"
echo "config.toml synced from local config"

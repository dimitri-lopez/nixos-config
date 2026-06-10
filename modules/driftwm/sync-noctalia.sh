#!/bin/sh
SRC="$HOME/.config/noctalia/settings.json"
DST="$HOME/.dotfiles/modules/driftwm/noctalia.json"
cp "$SRC" "$DST"
echo "noctalia.json synced from GUI"

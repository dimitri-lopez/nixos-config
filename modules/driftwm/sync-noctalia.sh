#!/bin/sh
SRC="$HOME/.local/state/noctalia/settings.toml"
DST="$HOME/.dotfiles/modules/driftwm/noctalia.toml"
cp "$SRC" "$DST"
echo "noctalia.toml synced from GUI"

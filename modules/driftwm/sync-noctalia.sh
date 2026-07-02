#!/bin/sh
set -e
SRC="$HOME/.local/state/noctalia/settings.toml"
DST="$HOME/.dotfiles/modules/driftwm/noctalia.toml"
chmod +w "$DST" 2>/dev/null || true
cp "$SRC" "$DST"
cd "$HOME/.dotfiles"
git add "modules/driftwm/noctalia.toml" 2>/dev/null || true
echo "noctalia.toml synced from GUI"

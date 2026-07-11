#!/bin/sh
# sync.sh - Single entrypoint for applying dotfile changes.
# Also available globally as: dl-sync
# Usage:
#   ./sync.sh        -> home-manager only (default, fast)
#   ./sync.sh --full -> home-manager + nixos-rebuild (requires sudo)
#   ./sync.sh --config -> sync GUI configs back to repo only (no rebuild)
#
# Unlocks .nix files, tangles org sources, regenerates manifest, syncs noctalia,
# syncs driftwm config, rebuilds, then re-locks .nix files (source of truth is .org).

cd ~/.dotfiles || exit 1

CONFIG_ONLY=""
FULL_REBUILD=""
for arg in "$@"; do
    case "$arg" in
        --config) CONFIG_ONLY=1 ;;
        --full) FULL_REBUILD=1 ;;
    esac
done

if [ -z "$CONFIG_ONLY" ]; then
    # 1. Unlock generated .nix files so tangler can write
    find . -name "*.nix" ! -name "hardware-configuration.nix" -exec chmod 644 {} +

    # 2. Tangle with fallback chain: python -> emacs batch -> doom
    if command -v python3 >/dev/null 2>&1; then
        python3 tangle.py readme.org
    elif command -v emacs >/dev/null 2>&1; then
        emacs --batch -l org -f org-babel-tangle-file readme.org
    else
        doom +org tangle readme.org
    fi

    # 3. Regenerate agent manifest
    python3 manifest.py
fi

# 4. Sync noctalia settings from GUI back into repo
SCRIPT="$HOME/.dotfiles/modules/driftwm/sync-noctalia.sh"
if [ -f "$SCRIPT" ]; then
    sh "$SCRIPT"
fi

# 5. Sync driftwm config from local back into repo
if [ -x modules/driftwm/sync-config.sh ]; then
    ./modules/driftwm/sync-config.sh
fi

if [ -z "$CONFIG_ONLY" ]; then
    # 6. Rebuild
    if [ -n "$FULL_REBUILD" ]; then
        echo "Running full rebuild: home-manager + nixos-rebuild..."
        home-manager switch --flake .
        sudo nixos-rebuild switch --flake .
        echo "Full sync complete."
    else
        echo "Running home-manager switch only..."
        home-manager switch --flake .
        echo "Home sync complete."
    fi

    # 7. Lock .nix files (source of truth is .org)
    find . -name "*.nix" ! -name "hardware-configuration.nix" -exec chmod 444 {} +
else
    echo "Config sync complete (no rebuild)."
fi

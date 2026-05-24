#!/bin/sh
# sync.sh - Single entrypoint for applying dotfile changes.
# Unlocks .nix files, tangles org sources, regenerates manifest, syncs noctalia,
# rebuilds NixOS, then re-locks .nix files (source of truth is .org).

cd ~/.dotfiles || exit 1

# 1. Unlock generated .nix files so tangler can write
find . -name "*.nix" ! -name "hardware-configuration.nix" -exec chmod 644 {} +

# 2. Tangle with fallback chain: doom -> emacs batch -> python
if command -v doom >/dev/null 2>&1; then
    doom +org tangle readme.org
elif command -v emacs >/dev/null 2>&1; then
    emacs --batch -l org -f org-babel-tangle-file readme.org
else
    python3 tangle.py readme.org
fi

# 3. Regenerate agent manifest
python3 manifest.py

# 4. Sync noctalia settings from GUI back into repo
if [ -x ~/.local/bin/sync-noctalia ]; then
    ~/.local/bin/sync-noctalia
fi

# 5. Rebuild
home-manager switch --flake .
sudo nixos-rebuild switch --flake .

# 6. Lock .nix files (source of truth is .org)
find . -name "*.nix" ! -name "hardware-configuration.nix" -exec chmod 444 {} +

echo "Sync complete."

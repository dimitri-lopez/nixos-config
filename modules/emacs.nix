{ config, lib, pkgs, inputs, ... }:

let
  title2bib = import ./python-packages/title2bib.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  doi2bib = import ./python-packages/doi2bib.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  claude-agent-acp = import ./npm-packages/claude-agent-acp.nix {
    lib = lib;
    buildNpmPackage = pkgs.buildNpmPackage;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  free-coding-models = import ./npm-packages/free-coding-models.nix {
    lib = lib;
    buildNpmPackage = pkgs.buildNpmPackage;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
in
{

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.config/emacs/bin"
  ];

  # services.gvfs.enable = true; # needed for emacs tramp
  home.packages = with pkgs; [

    nix-init
    zip

    signal-cli
    signal-desktop
    imagemagick
    ffmpeg
    
    # agent shell
    gemini-cli
    claude-code
    claude-agent-acp
    free-coding-models
    # inputs.opencode.packages.${pkgs.system}.default
    (pkgs.writeScriptBin "opencode" "npx opencode-ai \"$@\"")
    
    # inputs.opencode.packages.${pkgs.system}.default
    gnuplot
    
    (pkgs.writeScriptBin "update-npm-tools" ''
#!/usr/bin/env bash
# usage: update-npm-tools free-coding-models 0.3.26
TOOL=$1
VERSION=$2
TARGET="$HOME/.dotfiles/modules/npm-packages/$TOOL.nix"

if [ -z "$TOOL" ] || [ -z "$VERSION" ]; then
    echo "Usage: update-npm-tools <tool-name> <version>"
    exit 1
fi

sed -i "s/version = \".*\";/version = \"$VERSION\";/" "$TARGET"
sed -i "s/hash = \".*\";/hash = \"sha256-0000000000000000000000000000000000000000000=\";/" "$TARGET"
sed -i "s/npmDepsHash = \".*\";/npmDepsHash = \"sha256-0000000000000000000000000000000000000000000=\";/" "$TARGET"

echo "Updated $TOOL to $VERSION. Now run 'home-manager switch' to get the new hashes."
'')
    
    # emacs     
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang

    cmake
    gnumake
    libtool
    mlocate

    graphviz # for org-roam
    ispell # for spell checking

    texliveFull
    xorg.xwininfo # needed for emacs everywhere
    unzip # for dired
    clang-tools # for clangd for emacs development
    pandoc
    poppler-utils # for pdftotext-mode
    tree # for gptel agent
    playwright-driver.browsers # for visual testing keybinding-visualizer
    playwright-test # CLI for running playwright tests

    mu
    ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.mu4e ]))
    # ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.etags ]))
    isync
    offlineimap
    tesseract # image to text
    yt-dlp # for getting youtube subs
    title2bib # for grabbing doi information
    doi2bib # for grabbing doi information

    pdf2svg # for inline pdfs
    inkscape # for svg to pdf conversion (needed by org-mode latex export)
    node-glob # for searching for files

    cbonsai

    cardo
    eb-garamond
    libertinus
    libre-baskerville
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    source-serif
    texlivePackages.forum
    

    stdenv.cc.cc.lib
    nodejs # needed for github copilot
    (pkgs.writeScriptBin "emenu"''
emacsclient -c -F '((name . "emenu-drun") (minibuffer . only) (width . 100) (height . 10) (undecorated . t))' -e '(emenu-drun)'
'')
    (pkgs.writeScriptBin "doom-git-clone-doom-repo-and-install" ''
#!/usr/bin/env bash
rm -rf ~/.config/emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
'')

    (pkgs.writeScriptBin "doom-git-clone-personal-repo-and-install"
      ''
rm -rf ~/.config/doom
git clone https://github.com/dimitri-lopez/.doom.d.git ~/.config/doom
~/.config/emacs/bin/doom sync
~/.config/emacs/bin/doom doctor
echo "Check out ~/.dotfiles/install.org" '')
    (pkgs.writeScriptBin "dl-restart-emacs-daemon" ''
#!/usr/bin/env bash

EMACSRUNNING="t"
EMACSSTATE=$(emacsclient -a false -e 't')
if [ "$EMACSRUNNING" = "$EMACSSTATE" ]; then
    # echo "Emacs daemon is running"
    notify-send 'Emacs Daemon' 'Restarting Emacs Daemon' -i ~/bin/BWEmacsIcon.png -t 3000
    emacsclient -e "(kill-emacs)"
else
    # echo "Emacs daemon is not running"
    notify-send 'Emacs Daemon' 'Starting up Emacs Daemon' -i ~/bin/BWEmacsIcon.png -t 3000
fi

emacs --daemon
notify-send 'Emacs Daemon' 'Daemon is now running' -i ~/bin/EmacsIcon.png -t 3000
    '')
    (pkgs.writeScriptBin "dl-jumpapp-emacs" ''
#!/usr/bin/env bash

EMACSRUNNING="t"
EMACSSTATE=$(emacsclient -a false -e 't')
if [ "$EMACSRUNNING" != "$EMACSSTATE" ]; then
    # echo "Emacs daemon is not running"
    notify-send 'Emacs Daemon' 'Starting up Emacs Daemon' -i ~/bin/BWEmacsIcon.png -t 3000
    emacs --daemon
fi

VAR1=$(jumpapp -m emacs --daemon 2>&1 >/dev/null)
VAR2="Error: found running process for 'emacs', but found no window to jump to"
if [ "$VAR1" = "$VAR2" ]; then
    # emacs client is not open
    emacsclient -c -a 'emacs'
else
    python /home/dimitril/bin/move-windows-to-workspace.py
fi
    '')
    (pkgs.writeScriptBin "org-tangle-tools" ''
#!/usr/bin/env bash
# Tangle org-subtree-tools to generate CLI tools
emacsclient --eval "(progn (find-file \"~/.config/doom/llm-tools/org-subtree-tools.org\") (org-babel-tangle) (kill-buffer))" 2>/dev/null || \
emacs --batch --eval "(progn (find-file \"~/.config/doom/llm-tools/org-subtree-tools.org\") (org-babel-tangle))"
    '')
  ];
}

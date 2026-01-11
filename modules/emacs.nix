{ config, lib, pkgs, ... }:

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
in
{

  home.sessionPath = [
    "~/.config/emacs/bin"
    "~/.dotfiles/tools/with-emacs.sh"
  ];

  # services.gvfs.enable = true; # needed for emacs tramp
  home.packages = with pkgs; [

    # agent shell
    gemini-cli
    claude-code



    
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
  ];
}

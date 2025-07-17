{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    emacs    # Emacs 27.2
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang

    cmake
    gnumake
    libtool

    graphviz

    texliveFull
    xorg.xwininfo # needed for emacs everywhere

    stdenv.cc.cc.lib
    nodejs # needed for github copilot
    (pkgs.writeScriptBin "restart-emacs-daemon" ''
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
    (pkgs.writeScriptBin "jumpapp-emacs" ''
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

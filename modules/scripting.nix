{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    jumpapp
    libnotify # forr sending notifcations
    wmctrl #for window management
    (pkgs.writeScriptBin "simulate-keystrokes" ''
#!/bin/sh
notify-send 'Simulate Keystrokes' 'Will type out current clipboard contents' -i ~/bin/KeyboardIconW.png -t 3500
notify-send 'Simulate Keystrokes' 'Will type in: 3' -t 1000
sleep 1
notify-send 'Simulate Keystrokes' 'Will type in: 2' -t 1000
sleep 1
notify-send 'Simulate Keystrokes' 'Will type in: 1' -t 1000
sleep 1
xdotool type -- "$(xsel -bo | tr \\n \\r | sed s/\\r*\$//)"
'')

  ];
}

{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    jumpapp
    libnotify # forr sending notifcations
    wmctrl #for window management
    (pkgs.writeScriptBin "dl-caps-lock-to-control" ''
setxkbmap -option caps:none && setxkbmap -option ctrl:nocaps && setxkbmap -option caps:ctrl && setxkbmap -option "shift:both_capslock"
'')

    (pkgs.writeScriptBin "dl-restart-wifi" ''
nmcli networking off
nmcli networking on
'')
    (pkgs.writeScriptBin "dl-simulate-keystrokes" ''
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

    (pkgs.writeScriptBin "dl-toggle-dev-workspace" ''
#!/usr/bin/env bash
# Toggle between current workspace and workspace 9 (dev/test workspace)

CURRENT=$(${pkgs.wmctrl}/bin/wmctrl -d | grep '\*' | cut -d' ' -f1)
DEV_WORKSPACE=8  # 0-indexed, so 8 = workspace 9

if [ "$CURRENT" = "$DEV_WORKSPACE" ]; then
    # Return to previous workspace (stored in file)
    PREV=$(cat /tmp/prev-workspace 2>/dev/null || echo 0)
    ${pkgs.wmctrl}/bin/wmctrl -s "$PREV"
else
    # Save current and switch to dev
    echo "$CURRENT" > /tmp/prev-workspace
    ${pkgs.wmctrl}/bin/wmctrl -s "$DEV_WORKSPACE"
fi
'')

    (pkgs.writeScriptBin "dl-visual-test-setup" ''
#!/usr/bin/env bash
# Set up isolated visual testing environment

# Switch to dev workspace
${pkgs.wmctrl}/bin/wmctrl -s 8

# Start test daemon if not running
if ! emacsclient -s visual-test --eval 't' 2>/dev/null; then
    doom emacs --daemon=visual-test
    sleep 2
fi

# Create frame in dev workspace
emacsclient -s visual-test -c &

echo "Visual test environment ready on workspace 9"
echo "Use: emacsclient -s visual-test --eval '...'"
'')

  ];
}

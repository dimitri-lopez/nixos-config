{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    package = pkgs.picom-pijulius;
    backend = "glx";
    settings = {
      blur-method = "dual_kawase";
      blur-strength = 5;
      blur-background = true;
      animations = true;
      animation-stiffness = 500;
      animation-window-mass = 1;
      animation-window-open = "effortless EaseInOut";
      animation-window-close = "effortless EaseInOut";
      fade = true;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      no-fading-openclose = false;
      shadow = true;
      shadow-opacity = 0.5;
    };
  };
  
  home.file.".xprofile".text = ''
#!/bin/sh
# X resources
xrdb -merge ~/.Xresources &

# Compton (picom) - compositor
picom -b &

# Tint2 bar
tint2 &

# Set wallpaper
feh --bg-fill ~/Dropbox/images/Truchas_LopezRanch_MW.jpg &

# Start Dropbox
dropbox start &

# Start Syncthing
syncthing --no-browser &

# Redshift for eye strain
redshift -l 42.361145:-71.057083 &

# Start Emacs daemon
sleep 1 && restart-emacs-daemon &

# Caps lock to control
dl-caps-lock-to-control &
'';
    
    # Start Emacs daemon
    sleep 1 && restart-emacs-daemon &
    
    # Caps lock to control
    dl-caps-lock-to-control &
  '';
  
  home.file.".Xresources".text = ''
    ! Xresources configuration for vxwm
    
    ! Cursor theme
    Xcursor.size: 24
    
    ! Window appearance
    URxvt*font: xft:Iosevka:size=10
    URxvt*boldFont: xft:Iosevka:bold:size=10
    URxvt*italicFont: xft:Iosevka:italic:size=10
    
    ! Transparency
    URxvt*depth: 32
    URxvt*background: [90]#000000
    
    ! Colors (Everforest-ish)
    URxvt*foreground: #d3c6aa
    URxvt*cursorColor: #a7c080
  '';

  home.file."~/.config/tint2/tint2rc".text = ''
    # Tint2 configuration
    
    # Panel
    panel = bottom
    panel_items = LTSC
    panel_size = 100% 30
    panel_margin = 0 5
    panel_padding = 5 0
    panel_background_id = 1
    
    # Battery
    battery = 1
    battery_icon = 0
    battery_tooltip = 1
    
    # Clock
    time1 = %H:%M
    time2 = %Y-%m-%d
    time_format = %H:%M
    tooltip_time_format = %Y-%m-%d
    
    # Launcher
    launcher_item_app = tint2conf
  '';

  home.packages = with pkgs; [
    picom-pijulius
    lemonbar
    tint2
    xdotool
    xauth
    xorg.xrandr
    feh
    arandr
  ];
}

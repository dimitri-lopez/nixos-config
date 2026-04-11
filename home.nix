{ config, pkgs, ... }:

{
imports = [
  # ./modules/xfce/xfce-home.nix
  ./modules/git.nix
  ./modules/phd.nix
  ./modules/itch.nix
  # ./modules/wm/hyprland-minimal.nix
  # ./modules/hyprland/hyprland-home.nix
  ./modules/python.nix
  ./modules/sh.nix
  ./modules/scripting.nix
  ./modules/emacs.nix
  ./modules/brave.nix
  ./modules/minecraft.nix
  ./modules/watchy.nix
];
# Home Manager needs a bit of information about you and the paths it should
# manage.
home.username = "dimitril";
home.homeDirectory = "/home/dimitril";

nixpkgs.config.allowUnfree = true;
nixpkgs.config.permittedInsecurePackages = [
  "python3.12-ecdsa-0.19.1"
];
# sessionPath = ["/home/dimitril/.config/emacs"];

# This value determines the Home Manager release that your configuration is
# compatible with. This helps avoid breakage when a new Home Manager release
# introduces backwards incompatible changes.
#
# You should not change this value, even if you update Home Manager. If you do
# want to update the value, then make sure to first check the Home Manager
# release notes.
home.stateVersion = "25.05"; # Please read the comment before changing.
# The home.packages option allows you to install Nix packages into your
# environment.
home.packages = [
  # # Adds the 'hello' command to your environment. It prints a friendly
  # # "Hello, world!" when run.
  # pkgs.hello

  # # It is sometimes useful to fine-tune packages, for example, by applying
  # # overrides. You can do that directly here, just don't forget the
  # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  # # fonts?
  # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')
];
# Home Manager is pretty good at managing dotfiles. The primary way to manage
# plain files is through 'home.file'.
home.file = {
  # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  # # symlink to the Nix store copy.
  # ".screenrc".source = dotfiles/screenrc;

  # # You can also set the file content immediately.
  # ".gradle/gradle.properties".text = ''
  #   org.gradle.console=verbose
  #   org.gradle.daemon.idletimeout=3600000
  # '';
};
# Home Manager can also manage your environment variables through
# 'home.sessionVariables'. These will be explicitly sourced when using a
# shell provided by Home Manager. If you don't want to manage your shell
# through Home Manager then you have to manually source 'hm-session-vars.sh'
# located at either
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/dimitril/etc/profile.d/hm-session-vars.sh
#
home.sessionVariables = {
  EDITOR = "emacsclient";
};
# Let Home Manager install and manage itself.
programs.home-manager.enable = true;
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
}

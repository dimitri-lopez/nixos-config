{ config, pkgs, inputs, lib, ... }:

let
  driftwmPkg = (inputs.driftwm.packages.${pkgs.stdenv.system}.default).overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      patch -d "$NIX_BUILD_TOP/cargo-vendor-dir" -p1 < ${./libdisplay-info-sys.patch}
    '';
  });
  driftwmConfig = pkgs.substituteAll {
    src = ./config.toml;
    polkit_gnome = pkgs.polkit_gnome;
  };
in
{
  imports = [ (import ../../modules/noctalia.nix { inherit config pkgs lib inputs; settingsFile = ./noctalia.toml; }) ../../modules/btop.nix ];
  home.activation.checkDriftwmConfig = lib.hm.dag.entryBefore ["copyDriftwmConfig"] ''
    ${driftwmPkg}/bin/driftwm --config ${driftwmConfig} --check-config || true
  '';
  
  home.activation.copyDriftwmConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "${config.home.homeDirectory}/.config/driftwm/config.toml" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/driftwm"
      install -m644 "${driftwmConfig}" "${config.home.homeDirectory}/.config/driftwm/config.toml"
    fi
  '';
  home.packages = with pkgs; [
    driftwmPkg
    fuzzel
    swaylock
    swayidle
    wlrctl
    alacritty
    grim
    ffmpeg
    polkit_gnome
    elementary-xfce-icon-theme
    everforest-gtk-theme
    ptyxis
    gnome-clocks
    brightnessctl
    libnotify
    wtype
    xwayland
    xwayland-satellite
    btop
    cliphist
    wl-clipboard
    xfce.thunar
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    slurp
    wlopm
      
  ];
  home.file = {
    ".local/share/icons/elementary-pastel/index.theme".text = ''
      [Icon Theme]
      Name=elementary-pastel
      Comment=Elementary icons with Mignon-pastel app icons
      Inherits=elementary,Adwaita,hicolor
  
      Directories=scalable/apps
      ScaledDirectories=scalable@2x/apps
  
      [scalable/apps]
      Context=Applications
      Size=64
      MinSize=16
      MaxSize=512
      Type=Scalable
  
      [scalable@2x/apps]
      Context=Applications
      Scale=2
      Size=64
      MinSize=16
      MaxSize=512
      Type=Scalable
    '';
  
    ".config/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Adwaita-dark
      gtk-icon-theme-name=elementary-pastel
      gtk-cursor-theme-name=elementary
      gtk-application-prefer-dark-theme=1
    '';
  
    ".local/share/driftwm-sample/scripts/lock.sh" = {
      text = ''
      #!/bin/sh
      ${pkgs.grim}/bin/grim -l 0 /tmp/lockscreen.png
      ${pkgs.ffmpeg}/bin/ffmpeg -y -i /tmp/lockscreen.png -vf "boxblur=8:2" /tmp/lockblur.png 2>/dev/null
      ${pkgs.swaylock}/bin/swaylock -f -i /tmp/lockblur.png
      '';
      executable = true;
    };
  
    ".local/share/driftwm-sample/scripts/lock-with-caffeine.sh" = {
      text = ''
      #!/bin/sh
      ${pkgs.grim}/bin/grim -l 0 /tmp/lockscreen.png
      ${pkgs.ffmpeg}/bin/ffmpeg -y -i /tmp/lockscreen.png -vf "boxblur=8:2" /tmp/lockblur.png 2>/dev/null
      ${pkgs.systemd}/bin/systemd-inhibit --what=sleep --who="Manual lock" --why="Remote access while locked" \
        ${pkgs.swaylock}/bin/swaylock -i /tmp/lockblur.png
      '';
      executable = true;
    };
  
    ".local/share/driftwm-sample/scripts/sync-noctalia.sh" = {
      text = ''
        #!/bin/sh
        set -e
        SRC="${config.home.homeDirectory}/.local/state/noctalia/settings.toml"
        DST="${config.home.homeDirectory}/.dotfiles/modules/driftwm/noctalia.toml"
        chmod +w "$DST" 2>/dev/null || true
        cp "$SRC" "$DST"
        cd "${config.home.homeDirectory}/.dotfiles"
        git add "modules/driftwm/noctalia.toml" 2>/dev/null || true
        echo "noctalia.toml synced from GUI settings"
      '';
      executable = true;
    };
  };
  systemd.user.startServices = "sd-switch";
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}

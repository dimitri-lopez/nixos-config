{ config, lib, pkgs, userSettings, ... }:

let
  hostname = lib.strings.fileContents /etc/hostname;
in
{
  imports = let
    hostname = lib.strings.fileContents /etc/hostname;
  in [
    ./modules/common.nix
    ./modules/git.nix
    ./modules/phd.nix
    ./modules/python.nix
    ./modules/sh.nix
    ./modules/scripting.nix
    ./modules/emacs.nix
    ./modules/brave.nix
    ./modules/minecraft.nix
    ./modules/watchy.nix
    ./modules/mcp-nixos.nix
    ./modules/llms.nix
  ] ++ lib.optionals (hostname == "p14s" || hostname == "t14s") [
    ./modules/driftwm/home.nix
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
  { modulesPath, inputs, pkgs, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware-configuration.nix
      ../../configuration.nix
      ../../system/remote.nix
      ../../modules/driftwm/system.nix
    ];
  
    networking.hostName = "p14s";
  
    boot.resumeDevice = "/dev/disk/by-uuid/f07a843d-3591-4bde-8ce0-24b53fd457a4";
    boot.kernelParams = [ "resume=UUID=f07a843d-3591-4bde-8ce0-24b53fd457a4" ];
  
    # mt7925e driver mutex bug — unload before sleep/reload after
    systemd.sleep.extraConfig = ''
      HibernateMode=shutdown
    '';
  
    environment.etc."systemd/system-sleep/mt7925e-workaround.sh" = {
      text = ''
        #!/bin/sh
        case $1/$2 in
          pre/suspend|pre/hibernate)  ${pkgs.kmod}/bin/modprobe -r mt7925e ;;
          post/suspend|post/hibernate) ${pkgs.kmod}/bin/modprobe mt7925e ;;
        esac
      '';
      mode = "0755";
    };
  
    # Disable PCIe root port wakeups (EC wake bug on S4)
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
    '';
  }
  { modulesPath, inputs, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware-configuration.nix
      ../../configuration.nix
      ../../modules/driftwm/system.nix
    ];
  
    networking.hostName = "t14s";
  
    boot.resumeDevice = "/dev/disk/by-uuid/75bde775-be2a-4135-a34d-c18cd526f54e";
    boot.kernelParams = [ "resume=UUID=75bde775-be2a-4135-a34d-c18cd526f54e" ];
  }
}

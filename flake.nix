{
  description = "dimitril's flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    hyprland-plugins = {
      url = "github:hyprwm/Hyprland-Plugins";
      inputs.hyprland.follows = "hyprland";
    };
    raise.url = "github:knarkzel/raise";
    opencode.url = "github:AodhanHayter/opencode-flake";
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      userSettings = {
        username = "dimitril";
        name = "Dimitri";
        email = "dimitrilopez01@gmail.com";
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        # Options: "xfce", "vxwm", "hyprland" - desktop modules auto-loaded in flake.nix
        wm = "vxwm"; 
        # editor = "emacsclient -c -a 'emacs'"
      };
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "dimitril-hostname";   # hostname
      };
      vxwm = pkgs.stdenv.mkDerivation {
        pname = "vxwm";
        version = "unstable";
        src = pkgs.fetchgit {
          url = "https://codeberg.org/wh1tepearl/vxwm.git";
          rev = "24bbb12074704680edf894ea82a066b3b2662c42";
          sha256 = "01ggidzvb44m8s179d4had7lrvzrmxapp84dhirbygpxfzn6gsiz";
        };
        nativeBuildInputs = with pkgs; [ pkg-config libX11 libXft libXinerama ];
        buildInputs = with pkgs; [ libX11 libXft libXinerama ];
        installPhase = ''
          make DESTDIR=$out install
        '';
      };
      
      selectedDesktop = {
        xfce = {
          system = [ ./modules/xfce/xfce.nix ];
          home = [ ./modules/xfce/xfce-home.nix ];
        };
        vxwm = {
          system = [];
          home = [ ./modules/vxwm-home.nix ];
        };
        hyprland = {
          system = [ ./system/hyprland.nix ];
          home = [ ./modules/wm/hyprland-minimal.nix ./modules/hyprland/hyprland-home.nix ];
        };
      }.${userSettings.wm} or (throw "Invalid wm: ${userSettings.wm}");
    in {
      packages = {
        x86_64-linux.vxwm = vxwm;
        x86_64-linux.vxwm-unstable = vxwm;
        default = vxwm;
      };
      legacyPackages.x86_64-linux = {
        inherit vxwm;
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ] ++ selectedDesktop.system;
        };
      };
      homeConfigurations = {
        "dimitril" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ] ++ selectedDesktop.home;
          extraSpecialArgs = {
            inherit userSettings;
            inherit inputs;
          };
        };
      };
    };
}

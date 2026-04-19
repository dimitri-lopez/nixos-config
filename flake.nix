{
  description = "dimitril's flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/Hyprland-Plugins";
      inputs.hyprland.follows = "hyprland";
    };
    raise.url = "github:knarkzel/raise";
    opencode.url = "github:AodhanHayter/opencode-flake";
    srwc = {
      url = "github:infraflakes/srwc";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
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
        # Options: "xfce", "vxwm", "hyprland", "srwc" - desktop modules auto-loaded in flake.nix
        wm = "srwc"; 
        # editor = "emacsclient -c -a 'emacs'"
      };
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "dimitril-hostname";   # hostname
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
        srwc = {
          system = [ ];
          home = [ ./modules/srwc-home.nix ];
        };
      }.${userSettings.wm} or (throw "Invalid wm: ${userSettings.wm}");
    in {
      packages.x86_64-linux = {
      };
      legacyPackages.x86_64-linux = {
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ] ++ selectedDesktop.system;
          specialArgs = { inherit inputs; };
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

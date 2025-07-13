{
  description = "dimitril's flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      userSettings = {
        username = "dimitril";
        name = "Dimitri";
        email = "dimitrilopez01@gmail.com";
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        # wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        # editor = "emacsclient -c -a 'emacs'"
      };
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "dimitril-hostname";   # hostname
      };
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };
      };
      homeConfigurations = {
        "dimitril" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit userSettings;
          };
        };
      };
    };
}

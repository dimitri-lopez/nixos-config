{
  description = "dimitril's flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  
    opencode.url = "github:AodhanHayter/opencode-flake";
    driftwm = {
      url = "github:malbiruk/driftwm";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  
    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
    };
  
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
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
        # Options: "xfce", "driftwm" - desktop modules auto-loaded in flake.nix
        wm = "driftwm";
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
        driftwm = {
          system = [ ./modules/driftwm/system.nix ];
          home = [ ./modules/driftwm/home.nix ];
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

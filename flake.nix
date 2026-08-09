{
  description = "dimitril's flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  
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
      };
      systemSettings = {
      system = "x86_64-linux"; # system arch
      };
    in {
      packages.x86_64-linux = {
      };
      legacyPackages.x86_64-linux = {
      };
      nixosConfigurations = {
        p14s = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/p14s ];
          specialArgs = { inherit inputs; };
        };
        t14s = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/t14s ];
          specialArgs = { inherit inputs; };
        };
        yoga = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/yoga ];
          specialArgs = { inherit inputs; };
        };
      };
      homeConfigurations = {
        "dimitril@p14s" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit inputs userSettings;
            hostname = "p14s";
          };
        };
        "dimitril@t14s" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit inputs userSettings;
            hostname = "t14s";
          };
        };
        "dimitril@yoga" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit inputs userSettings;
            hostname = "yoga";
          };
        };
      };
    };
}

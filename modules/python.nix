{ config, lib, pkgs, ... }:

let
  pytrends = import ./python-packages/pytrends.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
in
{
  home.packages = with pkgs; [
    (python312.withPackages (python3Packages: with python3Packages; [
      jupyter
      conda
      numpy
      sympy
      pandas
      scipy
      matplotlib
      seaborn
      plotly
      networkx
      requests
      markdownify
      discordpy
      folium
      fastparquet
      pyarrow
      qrcode

      # nXGF dependencies
      jax
      optax
      blackjax
      tqdm

      pytrends
    ]))
  ];
}

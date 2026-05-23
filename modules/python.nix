{ config, lib, pkgs, ... }:

let
  epidatpy = import ./python-packages/epidatpy.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  epiweeks = import ./python-packages/epiweeks.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  tailestim = import ./python-packages/tailestim.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  powerlaw = import ./python-packages/powerlaw.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  epydemix = import ./python-packages/epydemix.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
    fetchurl = pkgs.fetchurl;
  };
  evalidate = import ./python-packages/evalidate.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchurl = pkgs.fetchurl;
  };
in
# let
#   pytrends = import ./python-packages/pytrends.nix {
#     lib = lib;
#     python3 = pkgs.python312;
#     fetchFromGitHub = pkgs.fetchFromGitHub;
#   };
# in
{
  home.packages = with pkgs; [
    uv
    (python312.withPackages (python3Packages: with python3Packages; [
      jupyter
      colour # personal
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
      opencv4
      # brazil
      geojson

      # influenza forecasting
      python-dotenv
      epidatpy
      epiweeks
      us

      # nXGF dependencies
      jax
      optax
      blackjax
      tqdm
      joblib

      #netsci 1 project
      google-genai
      scikit-learn
      diskcache
      graph-tool
      geopandas
      # stats project
      statsmodels
      
      # network science 2 class
      powerlaw
      tailestim
      epydemix

      pyyaml
      streamlit
    ]))
  ];
}

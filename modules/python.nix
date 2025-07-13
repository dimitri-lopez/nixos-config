{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (python312.withPackages (python3Packages: with python3Packages; [
      jupyter

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
    ]))
  ];
}

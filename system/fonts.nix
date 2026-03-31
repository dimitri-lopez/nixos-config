{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    cardo
    eb-garamond
    libertinus
    libre-baskerville
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    source-serif
    texlivePackages.forum
  ];
}

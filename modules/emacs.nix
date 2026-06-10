{ config, lib, pkgs, inputs, ... }:

let
  title2bib = import ./python-packages/title2bib.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  doi2bib = import ./python-packages/doi2bib.nix {
    lib = lib;
    python3 = pkgs.python312;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  claude-agent-acp = import ./npm-packages/claude-agent-acp.nix {
    lib = lib;
    buildNpmPackage = pkgs.buildNpmPackage;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
  free-coding-models = import ./npm-packages/free-coding-models.nix {
    lib = lib;
    buildNpmPackage = pkgs.buildNpmPackage;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
in
{

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.config/emacs/bin"
  ];

  home.packages = with pkgs; [
  
    nix-init
    zip
  
    signal-cli
    signal-desktop
    imagemagick
    ffmpeg
      
    gnupg # for decoding secrets!
    pinentry # for decoding gpg
      
    # agent shell
    gemini-cli
    claude-code
    claude-agent-acp
    free-coding-models
    # inputs.opencode.packages.${pkgs.system}.default
    (pkgs.writeShellScriptBin "opencode" "exec npx opencode-ai \"$@\"")
      
    gnuplot
      
    <<emacs.scripts>>
      
    # emacs30-gtk3
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang
  
    cmake
    gnumake
    libtool
    mlocate
  
    graphviz # for org-roam
    ispell # for spell checking
  
    texliveFull
    xorg.xwininfo # needed for emacs everywhere
    unzip # for dired
    clang-tools # for clangd for emacs development
    pandoc
    poppler-utils # for pdftotext-mode
    tree # for gptel agent
    playwright-driver.browsers # for visual testing keybinding-visualizer
    playwright-test # CLI for running playwright tests
  
    mu
    ((emacsPackagesFor emacs30-gtk3).emacsWithPackages (epkgs: [ epkgs.mu4e ]))
  
    # Neomacs (GPU-accelerated Emacs - for testing)
    # inputs.neomacs.packages.${pkgs.system}.default
  
    # ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.etags ]))
    isync
    offlineimap
    tesseract # image to text
    yt-dlp # for getting youtube subs
    title2bib # for grabbing doi information
    doi2bib # for grabbing doi information
  
    pdf2svg # for inline pdfs
    inkscape # for svg to pdf conversion (needed by org-mode latex export)
    node-glob # for searching for files
  
    cbonsai
  
    cardo
    eb-garamond
    libertinus
    libre-baskerville
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    source-serif
    texlivePackages.forum
      
  
    stdenv.cc.cc.lib
    nodejs # needed for github copilot
  ];
}

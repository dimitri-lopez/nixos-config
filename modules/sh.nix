{ config, lib, pkgs, userSettings, ... }:
let
  myAliases = {
    ll = "ls -la";
    ec = "emacsclient";
    myname = "echo " + userSettings.username;
    driftwm-check = "driftwm --config ~/.config/driftwm/config.toml --check-config";
  };
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
    initContent = ''
    export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
    export XDG_STATE_HOME="''${XDG_STATE_HOME:-$HOME/.local/state}"
    export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"
    PROMPT=" - %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
     %F{green}→%f "
    RPROMPT="%F{red}|%f%F{yellow}|%f%F{green}|%f%F{cyan}|%f%F{blue}|%f%F{magenta}|%f%F{white}|%f"
    [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
    bindkey '^P' history-beginning-search-backward
    bindkey '^N' history-beginning-search-forward
    '';
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
    initExtra = ''
    export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
    export XDG_STATE_HOME="''${XDG_STATE_HOME:-$HOME/.local/state}"
    export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"
    '';
  };

  home.packages = with pkgs; [
    # disfetch lolcat cowsay onefetch
    # gnugrep gnused
    # bat eza bottom fd bc
    # direnv nix-direnv
      
        (pkgs.writeScriptBin "dl-home-manager-sync" ''
    #!/usr/bin/env bash
    cd ~/.dotfiles/
    python3 tangle.py readme.org && home-manager switch --flake .
        '')
        (pkgs.writeScriptBin "dl-nix-system-sync" ''
    #!/usr/bin/env bash
    cd ~/.dotfiles/
    python3 tangle.py readme.org && sudo nixos-rebuild switch --flake .
        '')
        (pkgs.writeScriptBin "dl-sync" ''
    #!/usr/bin/env bash
    # dl-sync - global entrypoint for dotfile changes.
    # Usage:
    #   dl-sync        -> home-manager only (default, fast)
    #   dl-sync --full -> home-manager + nixos-rebuild (requires sudo)
    exec ~/.dotfiles/sync.sh "$@"
        '')
  ];

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;
}

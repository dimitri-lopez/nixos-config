{ config, pkgs, userSettings, ... }:

{
  home.packages = [
    pkgs.git
    pkgs.git-credential-manager
    pkgs.gh
                  ];
  programs.git.enable = true;
  programs.git.userName = userSettings.name;
  programs.git.userEmail = userSettings.email;
  programs.git.extraConfig = {
    credential."https://github.com".helper = "!gh auth git-credential";
    credential."https://gist.github.com".helper = "!gh auth git-credential";
    # init.defaultBranch = "main";
    # safe.directory = [ ("/home/" + userSettings.username + "/.dotfiles")
    #                    ("/home/" + userSettings.username + "/.dotfiles/.git") ];
  };
}

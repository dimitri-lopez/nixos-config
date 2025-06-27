{ config, lib, pkgs, ... }:
# https://stackoverflow.com/questions/8946325/chrome-extension-id-how-to-find-it
{

  programs.chromium = {
    enable = true;
    package = pkgs.brave;

    # https://www.reddit.com/r/NixOS/comments/1bqilmi/how_to_configure_brave_browser_package_to_install/
    # Look at the url for the id either on the chrome web store or within the brave extensions page
    extensions = [
      # https://chromewebstore.google.com/detail/bitwarden-password-manage/nngceckbapebfimnlniiiahkandclblb
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      # https://chromewebstore.google.com/detail/grammarly-ai-writing-and/kbfnbcaeplbcioakkpcpgfkobkghlhen
      { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; }
      # https://chromewebstore.google.com/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg
      { id = "hfjbmagddngcpeloejdejnfgbamkjaeg";}
      # https://chromewebstore.google.com/detail/youtube-ad-accelerator-ea/lmcggcabhocpfkbddekmconplfjmmgmn
      { id = "lmcggcabhocpfkbddekmconplfjmmgmn";}
      # https://chromewebstore.google.com/detail/wallabagger/gbmgphmejlcoihgedabhgjdkcahacjlj?hl=en
      {id = "gbmgphmejlcoihgedabhgjdkcahacjlj";}
    ];
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };
  xdg.mimeApps.defaultApplications = {
  "text/html" = "brave-browser.desktop";
  "x-scheme-handler/http" = "brave-browser.desktop";
  "x-scheme-handler/https" = "brave-browser.desktop";
  "x-scheme-handler/about" = "brave-browser.desktop";
  "x-scheme-handler/unknown" = "brave-browser.desktop";
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
  };
}

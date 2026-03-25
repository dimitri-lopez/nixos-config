{ config, lib, pkgs, ... }:

let
  rEnv = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      ggcorrplot
      tidyverse
      ggplot2
      openintro
      infer
      GGally
      NHANES
    ];
  };

  # GLEAMviz - Global epidemic and mobility simulation tool
  # Downloaded from: https://www.gleamviz.org/download/
  # Direct link: https://www.gleamviz.org/simul/bin/GLEAMviz-7.2-linux-x64-installer.run
  #
  # This creates a simple wrapper script that downloads and installs GLEAMviz on first run
  gleamviz = pkgs.writeShellScriptBin "gleamviz" ''
    INSTALL_DIR="$HOME/.local/share/gleamviz"
    INSTALLER_URL="https://www.gleamviz.org/simul/bin/GLEAMviz-7.2-linux-x64-installer.run"
    
    # Check if GLEAMviz is already installed
    if [ ! -f "$INSTALL_DIR/gleamviz.sh" ]; then
      echo "GLEAMviz not found. Installing to $INSTALL_DIR..."
      mkdir -p "$INSTALL_DIR"
      
      # Download the installer to home directory (accessible to steam-run)
      TEMP_INSTALLER="$HOME/.cache/gleamviz-installer.run"
      mkdir -p "$HOME/.cache"
      
      if [ ! -f "$TEMP_INSTALLER" ]; then
        echo "Downloading GLEAMviz installer..."
        ${pkgs.curl}/bin/curl -L -o "$TEMP_INSTALLER" "$INSTALLER_URL"
        chmod +x "$TEMP_INSTALLER"
      else
        echo "Using cached installer..."
      fi
      
      # Run the installer in unattended mode
      echo "Running installer..."
      ${pkgs.steam-run}/bin/steam-run "$TEMP_INSTALLER" --mode unattended --prefix "$INSTALL_DIR"
      EXIT_CODE=$?
      
      if [ $EXIT_CODE -ne 0 ] || [ ! -f "$INSTALL_DIR/gleamviz.sh" ]; then
        echo ""
        echo "Automatic installation failed or unsupported."
        echo "Running interactive installer - please click through to install to:"
        echo "  $INSTALL_DIR"
        echo ""
        ${pkgs.steam-run}/bin/steam-run "$TEMP_INSTALLER" --prefix "$INSTALL_DIR"
      fi
      
      if [ -f "$INSTALL_DIR/gleamviz.sh" ]; then
        echo "Installation complete!"
        # Clean up installer after successful installation
        rm -f "$TEMP_INSTALLER"
      else
        echo "Error: Installation failed. GLEAMviz not found at $INSTALL_DIR/gleamviz.sh"
        echo "Installer has been saved to: $TEMP_INSTALLER"
        exit 1
      fi
    fi
    
    # Launch GLEAMviz
    exec ${pkgs.steam-run}/bin/steam-run "$INSTALL_DIR/gleamviz.sh" "$@"
  '';
in
{
  home.packages = with pkgs; [
    gephi
    gpick

    # Include the R environment
    rEnv

    # GLEAMviz epidemic simulator
    gleamviz

    # Other system packages
    zlib
    libxmlb
    libxml2
  ];

  # Desktop entry for GLEAMviz
  # Note: Icon will only appear after first run when GLEAMviz is installed
  xdg.desktopEntries.gleamviz = {
    name = "GLEAMviz";
    genericName = "Epidemic Simulator";
    comment = "Global epidemic and mobility model visualization";
    exec = "gleamviz";
    icon = "${config.home.homeDirectory}/.local/share/gleamviz/GLEAMviz64.png";
    terminal = false;
    categories = [ "Science" "Education" ];
  };

  # Ensure R can find its user-installed packages
  # This might be implicitly handled by rEnv, but explicit is safer
  # If you encounter issues, you might need to adjust R_LIBS_USER
  # home.sessionVariables = {
  #   R_LIBS_USER = "${pkgs.rWrapper}/lib/R/library";
  # };
}

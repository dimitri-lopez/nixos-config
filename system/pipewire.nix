{ ... }:

{

  # services = {
  #   blueman.enable = true;
  #   # gnome.gnome-keyring.enable = true;
  #   pipewire = { # multimedia framework
  #     enable = true;
  #     alsa = {
  #       enable = true;
  #       support32Bit = true;
  #     };
  #     pulse.enable = true;
  #   };
  # };

  # services.pulseaudio.enable = false;
  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };
}

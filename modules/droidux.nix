{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xournalpp
    android-tools
    (pkgs.callPackage ({ stdenv, fetchurl, xz }: stdenv.mkDerivation {
      pname = "droidux";
      version = "572f903";
      src = fetchurl {
        url = "https://github.com/leath-dub/droidux/releases/download/572f903/droidux-x86_64-linux-musl.xz";
        sha256 = "1wr5frj7ysp57c9zzw1hdhazlkfiqw96bqwdn3dan4xxzmn9683j";
      };
      nativeBuildInputs = [ xz ];
      dontBuild = true;
      dontConfigure = true;
      dontPatchShebangs = true;
      unpackPhase = "true";
      buildPhase = "true";
      installPhase = ''
        mkdir -p $out/bin
        xz -d <$src -c >$out/bin/droidux
        chmod +x $out/bin/droidux
      '';
    }) {})
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      droidux-connect = "droidux \"onyx_emp_Wacom I2C Digitizer\"";
    };
  };
}

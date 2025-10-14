{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pyobjc";
  version = "11.1";

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "pyobjc";
    rev = "v${version}";
    hash = "sha256-vbw9F2CQRykP+042lTUL7hrJ2rVWnjk9JMKnUdPWTGQ=";
  };

  meta = {
    description = "The Python <-> Objective-C Bridge with bindings for macOS frameworks";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pyobjc";
    platforms = lib.platforms.all;
  };
}

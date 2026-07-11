{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "copilot-language-server";
  version = "1.517.0";

  src = fetchzip {
    url = "https://github.com/github/copilot-language-server-release/releases/download/${version}/copilot-language-server-native-${version}.zip";
    hash = "sha256-Oq7UjcEUPtuCDjcbWYup1tefk7LpJJ3/bm+Hq5yaYwI=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install "linux-x64/copilot-language-server" -Dm755 -t "$out"/bin
    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Use GitHub Copilot with any editor or IDE via the Language Server Protocol";
    homepage = "https://github.com/features/copilot";
    license = lib.licenses.unfree;
    mainProgram = "copilot-language-server";
    platforms = [ "x86_64-linux" ];
  };
}

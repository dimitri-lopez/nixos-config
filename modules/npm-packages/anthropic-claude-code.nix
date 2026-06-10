{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
  gcc-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "anthropic-claude-code";
  version = "2.1.170";

  src = fetchurl {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code-linux-x64/-/claude-code-linux-x64-${version}.tgz";
    hash = "sha256-WgnUx2ErN0L9rrGmQUh5jGqnldv9dYcQnTva15zNU/8=";
  };

  sourceRoot = "package";

  nativeBuildInputs = [ autoPatchelfHook ];
  
  buildInputs = [
    glibc
    gcc-unwrapped.lib
  ];

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    
    # Find the claude binary in the package
    if [ -f bin/claude ]; then
      cp bin/claude $out/bin/claude-latest
      chmod +x $out/bin/claude-latest
    elif [ -f claude ]; then
      cp claude $out/bin/claude-latest  
      chmod +x $out/bin/claude-latest
    else
      echo "Searching for claude binary..."
      find . -name "claude" -type f -executable | head -1 | while read -r binary; do
        if [ -n "$binary" ]; then
          cp "$binary" $out/bin/claude-latest
          chmod +x $out/bin/claude-latest
        fi
      done
    fi
    
    # If we still don't have it, list contents to debug
    if [ ! -f $out/bin/claude-latest ]; then
      echo "Could not find claude binary. Package contents:"
      find . -type f | head -20
    fi
    
    runHook postInstall
  '';

  meta = {
    description = "Official Claude Code from Anthropic - latest version";
    homepage = "https://www.npmjs.com/package/@anthropic-ai/claude-code-linux-x64";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "claude-latest";
    platforms = [ "x86_64-linux" ];
  };
}

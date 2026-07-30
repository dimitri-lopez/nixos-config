{ lib, stdenvNoCC, fetchurl, unzip }:

let
  version = "17.1.8";

  # Bun 1.3.14 — fetched directly from GitHub releases (not yet in nixpkgs)
  bun_1_3_14 = stdenvNoCC.mkDerivation {
    pname = "bun";
    version = "1.3.14";
    src = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.14/bun-linux-x64.zip";
      hash = "sha256-lR7iruhV8IWVruxiJSJqKY0/6oOj3NZGXAnLzN9+hI8=";
    };
    nativeBuildInputs = [ unzip ];
    installPhase = ''
      mkdir -p $out/bin
      cp bun $out/bin/bun
      chmod +x $out/bin/bun
    '';
    meta.mainProgram = "bun";
  };

  src = fetchurl {
    url = "https://registry.npmjs.org/@oh-my-pi/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
    hash = "sha256-DcrCHnFXIH3zMFL8r/4kQm5tLkHJZKoAZsoMf+MKUvQ=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "oh-my-pi";
  inherit version;

  inherit src;
  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/@oh-my-pi/pi-coding-agent
    cp -r . $out/lib/node_modules/@oh-my-pi/pi-coding-agent/
    runHook postInstall
  '';

  passthru.bun = bun_1_3_14;

  meta = {
    description = "AI Coding agent for the terminal — hash-anchored edits, LSP, Python, browser, subagents";
    homepage = "https://omp.sh";
    license = lib.licenses.mit;
    mainProgram = "oh-my-pi";
    platforms = [ "x86_64-linux" ];
  };
}

{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  bun,
}:

stdenvNoCC.mkDerivation rec {
  pname = "oh-my-pi";
  version = "17.0.9";

  src = fetchurl {
    url = "https://registry.npmjs.org/@oh-my-pi/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
    hash = "sha256-Ivqthnsg8gcf8jq/aVhu4+18XRJkts0XGIeAx2kE8Y8=";
  };

  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bun ];

  buildPhase = ''
    runHook preBuild
    HOME=$TMPDIR bun install --production --no-summary --frozen-lockfile 2>&1 || true
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/@oh-my-pi/pi-coding-agent
    cp -r . $out/lib/node_modules/@oh-my-pi/pi-coding-agent/
    mkdir -p $out/bin
    makeWrapper ${bun}/bin/bun $out/bin/omp \
      --add-flags "$out/lib/node_modules/@oh-my-pi/pi-coding-agent/dist/cli.js" \
      --set HOME "$HOME"
    runHook postInstall
  '';

  meta = {
    description = "AI Coding agent for the terminal — hash-anchored edits, LSP, Python, browser, subagents";
    homepage = "https://omp.sh";
    license = lib.licenses.mit;
    mainProgram = "omp";
    platforms = [ "x86_64-linux" ];
  };
}

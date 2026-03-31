{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.14.0";
  

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-6z0929OquI1s6EtQFjxel1p5dF/ep2hnVGLgKjudj88="; # UPDATE ME
  };
  
  postInstall = ''
    mv $out/bin/claude-code-acp $out/bin/claude-agent-acp
  '';

  npmDepsHash = "sha256-6DS1e9KxM+E6dj49xucxwXJnXbw2ILLe3fNLQyDpt0w="; # UPDATE ME

  meta = {
    description = "Use Claude Code from any ACP client such as Zed";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "claude-agent-acp";
  };
}

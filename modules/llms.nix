{ config, lib, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  oh-my-pi-src = import ./llms/oh-my-pi.nix {
    inherit (pkgs) stdenvNoCC fetchurl unzip;
    inherit lib;
  };
  # Custom bun 1.3.14 fetched from GitHub releases (not yet in nixpkgs)
  bun_omp = oh-my-pi-src.passthru.bun;
  
  omp = pkgs.writeShellScriptBin "omp" ''
    OMP_DIR="$HOME/.local/share/omp"
    if [ ! -d "$OMP_DIR/node_modules" ]; then
      echo "Setting up oh-my-pi in $OMP_DIR..."
      mkdir -p "$OMP_DIR"
      cp -r "${oh-my-pi-src}/lib/node_modules/@oh-my-pi/pi-coding-agent"/* "$OMP_DIR/"
      ${bun_omp}/bin/bun install --cwd "$OMP_DIR" --production --no-summary
    fi
    exec ${bun_omp}/bin/bun "$OMP_DIR/dist/cli.js" "$@"
  '';
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    mcp = {
      nixos = {
        type = "local";
        command = ["mcp-nixos"];
      };
    };
    provider = {
      nvidia = {
        npm = "@ai-sdk/openai-compatible";
        name = "NVIDIA NIM";
        options = {
          baseURL = "https://integrate.api.nvidia.com/v1";
          apiKey = "{env:NVIDIA_API_KEY}";
        };
        models = {
          "qwen/qwen3-coder-480b-a35b-instruct" = {
            name = "Qwen3 Coder 480B";
          };
          "stepfun-ai/step-3.5-flash" = {
            name = "Step 3.5 Flash";
          };
        };
      };
    };
    permission = {
      task = "deny";
    };
    model = "opencode-go/deepseek-v4-flash";
    agent = {
      plan = {
        model = "opencode-go/deepseek-v4-pro";
        reasoningEffort = "high";
      };
      build = {
        model = "opencode-go/deepseek-v4-flash";
        reasoningEffort = "high";
      };
      explore = {
        model = "opencode-go/deepseek-v4-flash";
        reasoningEffort = "high";
      };
    };
  };
in
{
  home.packages = [
    oh-my-pi-src
    unstable.opencode
    omp
  ];
  
  home.activation.installOmpDeps = lib.hm.dag.entryAfter ["linkGeneration"] ''
    omp_store="${oh-my-pi-src}/lib/node_modules/@oh-my-pi/pi-coding-agent"
    omp_dir="$HOME/.local/share/omp"
    if [ ! -d "$omp_dir/node_modules" ] && [ -d "$omp_store" ]; then
      echo "Setting up oh-my-pi in $omp_dir..."
      mkdir -p "$omp_dir"
      cp -r "$omp_store"/* "$omp_dir/"
      ${bun_omp}/bin/bun install --cwd "$omp_dir" --production --no-summary
    fi
  '';
  xdg.configFile."opencode/opencode.json" = {
    text = builtins.toJSON opencodeConfig;
  };
}

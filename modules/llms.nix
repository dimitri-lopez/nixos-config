{ config, lib, pkgs, inputs, ... }:

let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    mcpServers = {
      nixos = {
        command = "mcp-nixos";
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
    inputs.opencode.packages.${pkgs.system}.default
  ];
  xdg.configFile."opencode/opencode.json" = {
    text = builtins.toJSON opencodeConfig;
  };
}

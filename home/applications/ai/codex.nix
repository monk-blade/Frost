{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.ai.codex;
in {
  options.frost.home.apps.ai.codex.enable = lib.mkEnableOption "OpenAI Codex coding agent CLI";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    ];
  };
}

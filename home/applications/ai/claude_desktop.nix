{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.ai.claude_desktop;
in {
  options.frost.home.apps.ai.claude_desktop.enable = lib.mkEnableOption "Claude Desktop (official Linux build: Chat and Claude Code)";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
    ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.claude_code;
in {
  options.frost.home.apps.ai.claude_code.enable = lib.mkEnableOption "Claude Code agentic coding CLI";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.claude-code
    ];
  };
}

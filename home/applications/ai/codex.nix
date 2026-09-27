{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.codex;
in {
  options.frost.home.apps.ai.codex.enable = lib.mkEnableOption "OpenAI Codex coding agent CLI";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.codex
    ];
  };
}

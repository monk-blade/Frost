{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.direnv;
in {
  options.frost.home.apps.development.direnv.enable = lib.mkEnableOption "direnv with nix-direnv (auto-load per-project dev shells)";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}

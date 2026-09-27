{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.cursor;
in {
  options.frost.home.apps.development.cursor.enable = lib.mkEnableOption "Cursor AI code editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.code-cursor
    ];
  };
}

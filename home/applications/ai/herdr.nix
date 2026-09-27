{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.herdr;
in {
  options.frost.home.apps.ai.herdr.enable = lib.mkEnableOption "Herdr terminal agent multiplexer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.herdr
    ];
  };
}

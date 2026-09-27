{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.vlc;
in {
  options.frost.home.apps.utils.vlc.enable = lib.mkEnableOption "VLC media player";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vlc
    ];
  };
}

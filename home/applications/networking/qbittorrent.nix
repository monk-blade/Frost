{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.qbittorrent;
in {
  options.frost.home.apps.networking.qbittorrent.enable = lib.mkEnableOption "qBittorrent BitTorrent client";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.qbittorrent
    ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.aria2;
in {
  options.frost.home.apps.shell = {
    aria2.enable = lib.mkEnableOption "Aria2 Download tool";
  };

  config = lib.mkIf cfg.enable {
    programs.aria2 = {
      enable = true;
      systemd.enable = true;
      settings = {
        enable-rpc = true;
        rpc-listen-port = 6800;
      };
    };

    programs.aria2p = {
      enable = true;
      settings = {
        host = "http://localhost";
        port = 6800;
      };
    };
  };
}

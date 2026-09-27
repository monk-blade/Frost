{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.fwupd;
in {
  options.frost.hardware.fwupd = {
    enable = lib.mkEnableOption "fwupd firmware updates from LVFS";
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}

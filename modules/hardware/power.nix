{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.power;
in {
  options.frost.hardware.power = {
    enable = lib.mkEnableOption "Power management";
    thermald.enable = lib.mkEnableOption "Intel thermal daemon (keeps small-form-factor Intel CPUs from throttling hard)";
  };

  config = lib.mkIf cfg.enable {
    powerManagement.enable = true;
    services.thermald.enable = cfg.thermald.enable;
  };
}

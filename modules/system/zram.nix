{
  config,
  lib,
  ...
}: let
  cfg = config.frost.system.zram;
in {
  options.frost.system.zram = {
    enable = lib.mkEnableOption "compressed swap in RAM, with earlyoom to kill runaway processes before the system freezes";
  };

  config = lib.mkIf cfg.enable {
    zramSwap = {
      enable = true;
      memoryPercent = 50;
    };

    services.earlyoom.enable = true;
  };
}

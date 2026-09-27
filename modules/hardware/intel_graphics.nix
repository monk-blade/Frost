{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.hardware.intel_graphics;
in {
  options.frost.hardware.intel_graphics = {
    enable = lib.mkEnableOption "Intel iGPU with VA-API hardware video encode/decode (Broadwell and newer)";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = [pkgs.intel-media-driver];
    };

    environment.systemPackages = [pkgs.libva-utils];
  };
}

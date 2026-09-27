{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.sunshine;
in {
  options.frost.services.sunshine = {
    enable = lib.mkEnableOption "Sunshine game-stream host for Moonlight clients";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open Sunshine ports on all interfaces. Not needed for Tailscale, whose interface is already trusted.";
    };

    forceOutput = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "HDMI-A-1";
      description = "Connector forced on at boot so the compositor has an output to stream without a monitor. An HDMI dummy plug is more reliable.";
    };

    forceOutputMode = lib.mkOption {
      type = lib.types.str;
      default = "1920x1080@60";
      description = "Mode used for `forceOutput`.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      inherit (cfg) openFirewall;
    };

    boot.kernelParams = lib.optional (cfg.forceOutput != null) "video=${cfg.forceOutput}:${cfg.forceOutputMode}D";
  };
}

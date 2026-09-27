{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.mosh;
in {
  options.frost.services.mosh = {
    enable = lib.mkEnableOption "Mosh roaming-friendly remote shell";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open Mosh UDP ports on all interfaces. Not needed over Tailscale, whose interface is already trusted.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mosh = {
      enable = true;
      inherit (cfg) openFirewall;
    };
  };
}

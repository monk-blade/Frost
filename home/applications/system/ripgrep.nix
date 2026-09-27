{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.ripgrep;
in {
  options.frost.home.apps.system.ripgrep.enable = lib.mkEnableOption "ripgrep";

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      arguments = ["--smart-case"];
    };
  };
}

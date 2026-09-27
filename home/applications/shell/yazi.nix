{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.yazi;
in {
  options.frost.home.apps.shell.yazi.enable = lib.mkEnableOption "Yazi terminal file manager";

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

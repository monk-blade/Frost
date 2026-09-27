{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.atuin;
in {
  options.frost.home.apps.shell.atuin.enable = lib.mkEnableOption "Atuin searchable shell history (Ctrl-R)";

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = false;
        update_check = false;
        style = "compact";
      };
    };
  };
}

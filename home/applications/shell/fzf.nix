{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.fzf;
  fd = "${lib.getExe pkgs.fd} --hidden --exclude .git";
in {
  options.frost.home.apps.shell.fzf.enable = lib.mkEnableOption "fzf fuzzy finder with fd (Ctrl-T files, Alt-C directories)";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.fd];

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "${fd} --type f";
      fileWidgetCommand = "${fd} --type f";
      changeDirWidgetCommand = "${fd} --type d";
    };
  };
}

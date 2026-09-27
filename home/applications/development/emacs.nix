{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.emacs;
in {
  options.frost.home.apps.development.emacs.enable = lib.mkEnableOption "Emacs (native Wayland build)";

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
    };
  };
}

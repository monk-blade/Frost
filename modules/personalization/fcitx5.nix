{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.personalization.fcitx5;
in {
  options.frost.personalization.fcitx5 = {
    enable = lib.mkEnableOption "Fcitx5 input method framework";
    rime.enable = lib.mkEnableOption "Rime input engine";
    m17n.enable = lib.mkEnableOption "m17n engine (Indic layouts such as Gujarati InScript/phonetic)";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons =
          [
            pkgs.fcitx5-gtk
            pkgs.qt6Packages.fcitx5-configtool
          ]
          ++ lib.optional cfg.rime.enable pkgs.fcitx5-rime
          ++ lib.optional cfg.m17n.enable pkgs.fcitx5-m17n;
      };
    };
  };
}

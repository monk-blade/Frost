{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.wms.niri;
in {
  options.frost.desktop.wms = {
    niri.enable = lib.mkEnableOption "Niri scrollable-tiling Wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
  };
}

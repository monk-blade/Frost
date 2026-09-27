{
  config,
  lib,
  linkConfig,
  ...
}: let
  cfg = config.frost.home.ui.wms.niri;
in {
  options.frost.home.ui.wms = {
    niri.enable = lib.mkEnableOption "Niri user configuration";
  };

  config = lib.mkIf cfg.enable {
    # Only the main file is linked so DMS can write its generated includes to ~/.config/niri/dms/.
    xdg.configFile."niri/config.kdl".source = linkConfig "niri/config.kdl";
  };
}

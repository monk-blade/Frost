{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.environment.cursor;
in {
  options.frost.home.environment.cursor = {
    enable = lib.mkEnableOption "Bibata cursor theme";

    name = lib.mkOption {
      type = lib.types.str;
      default = "Bibata-Modern-Ice";
      example = "Bibata-Modern-Classic";
      description = "Cursor theme from the bibata-cursors package. The niri config sets its own cursor block, so keep both in sync.";
    };

    size = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Cursor size in pixels.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      inherit (cfg) name size;
      gtk.enable = true;
    };

    # GTK4/libadwaita apps on Wayland read the cursor from gsettings.
    dconf.settings."org/gnome/desktop/interface" = {
      cursor-theme = cfg.name;
      cursor-size = cfg.size;
    };
  };
}

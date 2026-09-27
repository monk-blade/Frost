{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.ui.tools.dms_theming;
  importDank = ''@import url("dank-colors.css");'';
  qtctSettings = qtct: {
    Appearance = {
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/${qtct}/colors/matugen.conf";
      style = "Fusion";
      icon_theme = "Adwaita";
    };
  };
in {
  options.frost.home.ui.tools.dms_theming = {
    enable = lib.mkEnableOption "wallpaper-based colors from DankMaterialShell's matugen for GTK, Qt, kitty and Emacs";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      # GTK: DMS writes dank-colors.css on every wallpaper change and switches between adw-gtk3 variants.
      home.packages = [pkgs.adw-gtk3];
      xdg.configFile."gtk-3.0/gtk.css".text = importDank;
      xdg.configFile."gtk-4.0/gtk.css".text = importDank;
      dconf.settings."org/gnome/desktop/interface" = {
        gtk-theme = "adw-gtk3-dark";
        color-scheme = "prefer-dark";
      };

      # Qt: qt5ct/qt6ct read the palette DMS writes to <qtct>/colors/matugen.conf.
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        qt5ctSettings = qtctSettings "qt5ct";
        qt6ctSettings = qtctSettings "qt6ct";
      };
    }

    (lib.mkIf config.programs.kitty.enable {
      programs.kitty.extraConfig = "globinclude dank-*.conf";
    })

    (lib.mkIf config.programs.emacs.enable {
      # DMS only renders the Emacs theme when ~/.emacs.d or ~/.config/emacs exists.
      xdg.configFile."emacs/themes/.keep".text = "";
      programs.emacs.extraConfig = ''
        (let ((dir (expand-file-name "themes" user-emacs-directory)))
          (add-to-list 'custom-theme-load-path dir)
          (when (file-exists-p (expand-file-name "dank-emacs-theme.el" dir))
            (load-theme 'dank-emacs t)))
      '';
    })
  ]);
}

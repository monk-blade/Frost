{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.dms.greetd;
in {
  options.frost.desktop.dms.greetd = {
    enable = lib.mkEnableOption "greetd login manager with tuigreet";

    command = lib.mkOption {
      type = lib.types.str;
      example = "niri-session";
      description = "Session command launched after login.";
    };

    autoLogin = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "frost";
      description = "User logged in automatically on boot. Logging out falls back to tuigreet.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings =
        {
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd ${lib.escapeShellArg cfg.command}";
            user = "greeter";
          };
        }
        // lib.optionalAttrs (cfg.autoLogin != null) {
          initial_session = {
            inherit (cfg) command;
            user = cfg.autoLogin;
          };
        };
    };
  };
}

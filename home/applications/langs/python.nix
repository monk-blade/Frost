{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.python;
in {
  options.frost.home.apps.langs.python = {
    enable = lib.mkEnableOption "Python language support";
    toolchain.enable = lib.mkEnableOption "Python interpreter and uv";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        pkgs.ruff # Janitor (ruff format) + Linter
        pkgs.ty # Brain (Static Type Analyzer)
      ]
      ++ lib.optionals cfg.toolchain.enable [
        pkgs.python3
        pkgs.uv
      ];
    home.sessionVariables = {
      UV_PYTHON_DOWNLOADS = "false";
    };
  };
}

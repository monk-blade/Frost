{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.go;
in {
  options.frost.home.apps.langs.go = {
    enable = lib.mkEnableOption "Go language support";
    toolchain.enable = lib.mkEnableOption "Go compiler";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        pkgs.gopls # Brain
        pkgs.gotools # Janitor (goimports)
        pkgs.go-tools # Diagnostics (staticcheck)
        pkgs.golangci-lint # Diagnostics
      ]
      ++ lib.optional cfg.toolchain.enable pkgs.go;
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.javascript;
in {
  options.frost.home.apps.langs.javascript = {
    enable = lib.mkEnableOption "JavaScript/TypeScript support";
    toolchain.enable = lib.mkEnableOption "Node.js runtime with npm";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        pkgs.vtsls # Brain
      ]
      ++ lib.optional cfg.toolchain.enable pkgs.nodejs;
  };
}

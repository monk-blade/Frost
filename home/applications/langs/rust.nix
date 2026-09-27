{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.rust;
in {
  options.frost.home.apps.langs.rust = {
    enable = lib.mkEnableOption "Rust language support";
    toolchain.enable = lib.mkEnableOption "stable Rust toolchain (rustc, cargo, clippy)";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        pkgs.rust-analyzer # Brain
        pkgs.rustfmt # Janitor
      ]
      ++ lib.optionals cfg.toolchain.enable [
        pkgs.rustc
        pkgs.cargo
        pkgs.clippy
        pkgs.gcc # linker and cc for build scripts
      ];
    home.sessionVariables = lib.mkIf cfg.toolchain.enable {
      RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    };
  };
}

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.ai.herdr;
in {
  options.frost.home.apps.ai.herdr.enable = lib.mkEnableOption "Herdr terminal agent multiplexer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
    ];
  };
}

{
  config,
  lib,
  ...
}: let
  cfg = config.frost.system.auto_upgrade;
in {
  options.frost.system.auto_upgrade = {
    enable = lib.mkEnableOption "nightly rebuild from a local flake checkout";

    flake = lib.mkOption {
      type = lib.types.str;
      example = "/home/frost/Frost#workstation";
      description = "Flake reference to rebuild from, including the configuration name.";
    };

    updateInputs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["nixpkgs"];
      description = "Inputs refreshed at build time. The checkout's flake.lock is left untouched.";
    };
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      inherit (cfg) flake;
      upgrade = false;
      flags = lib.concatMap (input: ["--update-input" input]) cfg.updateInputs ++ ["--no-write-lock-file" "-L"];
      dates = "04:00";
      randomizedDelaySec = "45min";
      allowReboot = false;
    };
  };
}

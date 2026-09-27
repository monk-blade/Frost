{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.desktop.tools.dank_material_shell;
in {
  imports = [
    inputs.dank-material-shell.nixosModules.default
  ];

  options.frost.desktop.tools.dank_material_shell = {
    enable = lib.mkEnableOption "DankMaterialShell (Quickshell desktop shell for niri/Hyprland)";
  };

  config = lib.mkIf cfg.enable {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
    };
  };
}

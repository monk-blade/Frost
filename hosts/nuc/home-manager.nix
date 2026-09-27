{
  stateVersion,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.frost.system.home_manager.enable {
    home-manager.users.frost = {
      imports = [../../home/users/frost.nix];
      home.username = "frost";
      home.homeDirectory = "/home/frost";
      home.stateVersion = stateVersion;
      home.sessionPath = [
        "$HOME/.local/bin"
      ];
      frost.home.ui.wms.niri.enable = true;
    };
  };
}

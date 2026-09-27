{
  stateVersion,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.frost.system.home_manager.enable {
    home-manager.users.arpan = {
      imports = [../../home/users/arpan.nix];
      home.username = "arpan";
      home.homeDirectory = "/home/arpan";
      home.stateVersion = stateVersion;
      home.sessionPath = [
        "$HOME/.local/bin"
      ];
    };
  };
}

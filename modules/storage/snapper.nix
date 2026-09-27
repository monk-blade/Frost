{
  config,
  lib,
  ...
}: let
  cfg = config.frost.storage.snapper;
in {
  options.frost.storage.snapper = {
    enable = lib.mkEnableOption "hourly Btrfs snapshots with snapper";

    subvolumes = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {home = "/home";};
      description = "Snapper config name to Btrfs subvolume mount point.";
    };

    allowUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Users allowed to list and restore snapshots without sudo.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.snapper.configs =
      lib.mapAttrs (_: path: {
        SUBVOLUME = path;
        ALLOW_USERS = cfg.allowUsers;
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 12;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 3;
        TIMELINE_LIMIT_YEARLY = 0;
      })
      cfg.subvolumes;

    # Snapper refuses to run without a .snapshots subvolume; "v" creates one on first boot.
    systemd.tmpfiles.rules = lib.mapAttrsToList (_: path: "v ${path}/.snapshots 0750 root root -") cfg.subvolumes;
  };
}

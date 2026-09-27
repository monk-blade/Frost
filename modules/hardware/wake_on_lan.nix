{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.wake_on_lan;
in {
  options.frost.hardware.wake_on_lan = {
    enable = lib.mkEnableOption "Wake-on-LAN (magic packet) on wired PCI Ethernet ports";
  };

  config = lib.mkIf cfg.enable {
    # A matching .link file replaces 99-default.link, so its naming policies are repeated here.
    systemd.network.links."50-wake-on-lan" = {
      matchConfig = {
        Type = "ether";
        Path = "pci-*";
      };
      linkConfig = {
        WakeOnLan = "magic";
        NamePolicy = "keep kernel database onboard slot path";
        AlternativeNamesPolicy = "database onboard slot path mac";
        MACAddressPolicy = "persistent";
      };
    };
  };
}

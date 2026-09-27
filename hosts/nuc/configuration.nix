{
  config,
  lib,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./users.nix
  ];

  # Remote desktop host: suspending would drop Tailscale and the Sunshine stream.
  systemd.targets = lib.genAttrs ["sleep" "suspend" "hibernate" "hybrid-sleep"] (_: {enable = false;});

  # Frost OS Modular Configuration
  frost = {
    desktop = {
      dms = {
        greetd = {
          enable = true;
          command = lib.getExe' config.programs.niri.package "niri-session";
          # Sunshine needs a running graphical session, so log in without a keyboard at boot.
          autoLogin = "frost";
        };
      };
      tools = {
        dank_material_shell.enable = true;
      };
      wms = {
        niri.enable = true;
      };
    };
    hardware = {
      bluetooth.enable = true;
      intel_graphics.enable = true;
      networking = {
        hostname = "frost-nuc";
        backend = "networkmanager";
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };
    personalization = {
      fonts.enable = true;
      locales.locale = "en_US.UTF-8";
      xdg.enable = true;
    };
    security = {
      gnome_keyring.enable = true;
      polkit.enable = true;
    };
    services = {
      ssh.user = "frost";
      sunshine = {
        enable = true;
        # No monitor or dummy plug? Force the HDMI port on instead:
        # forceOutput = "HDMI-A-1";
      };
      tailscale.enable = true;
    };
    system = {
      keymap = "us";
      home_manager.enable = true;
      autoTimezone = true;
    };
  };
}

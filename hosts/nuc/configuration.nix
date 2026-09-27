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
          autoLogin = "arpan";
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
      fwupd.enable = true;
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
      power = {
        enable = true;
        thermald.enable = true;
      };
      # Also enable Wake-on-LAN and "After Power Failure: Power On" in the BIOS.
      wake_on_lan.enable = true;
    };
    personalization = {
      fcitx5 = {
        enable = true;
        m17n.enable = true;
        rime.enable = true;
      };
      fonts = {
        enable = true;
        gujarati.enable = true;
      };
      locales.locale = "en_US.UTF-8";
      xdg.enable = true;
    };
    security = {
      gnome_keyring.enable = true;
      polkit.enable = true;
    };
    services = {
      mosh.enable = true;
      ssh = {
        user = "arpan";
        # Key-only SSH. Add your public key here, or use Tailscale SSH (`sudo tailscale up --ssh`).
        authorizedKeys = [];
      };
      sunshine = {
        enable = true;
        # No monitor or dummy plug? Force the HDMI port on instead:
        # forceOutput = "HDMI-A-1";
      };
      tailscale.enable = true;
    };
    storage = {
      # nix-ld: lets VS Code/Zed remote servers and prebuilt npm/pip binaries run.
      fhs.enable = true;
      snapper = {
        enable = true;
        allowUsers = ["arpan"];
      };
    };
    system = {
      # Rebuilds the local checkout nightly with the latest nixos-26.05 nixpkgs (security fixes).
      auto_upgrade = {
        enable = true;
        flake = "/home/arpan/Frost#nuc";
      };
      keymap = "us";
      home_manager.enable = true;
      autoTimezone = true;
      zram.enable = true;
    };
    virtualization = {
      docker.enable = true;
    };
  };
}

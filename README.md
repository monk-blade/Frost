# ❄️ Frost

> **Modular, Declarative NixOS Starter Framework & Flake Distribution**

Frost is an opinionated, highly modular NixOS framework and starter distribution. It separates reusable system and desktop infrastructure from personal fleet configuration, providing **110+ granular, toggleable modules** across system services, modern Wayland desktops, development tools, and user environments.

Frost is built from the ground up to be:
* **Zero Burnt-in Identity**: Purely anonymized and parameterized with no hardcoded credentials, secret keys, or personal paths.
* **Dual Consumption Model**: Use it directly as a standalone starter template (fork and customize) or consume it as an external Flake library in a private fleet repository.
* **Declarative Storage**: Integrated [Disko](https://github.com/nix-community/disko) partitioning with root-on-tmpfs / Btrfs ephemeral impermanence support.
* **Rapid Iteration**: Live dotfile hot-reloading via parameterized out-of-store symlinks without requiring full system rebuilds.
* **Automated Life-cycle**: Declarative installer and emergency recovery CLI apps (`frost-install` and `frost-recover`).

---

## 📂 Repository Layout

```text
Frost/
├── flake.nix               # Flake inputs, library exports, and starter configurations
├── installer/              # Automated installation & rescue tools (frost-install, frost-recover)
│   ├── install.sh
│   └── recover.sh
├── lib/                    # Helpers (mkSystem generator, recursive file scraper)
│   └── helpers/
├── hosts/                  # Host profiles & archetypes
│   ├── base.nix            # Core Nix settings (GC, flakes, trusted-users)
│   ├── boot.nix            # Standard systemd-boot loader configuration
│   ├── workstation/        # Starter graphical workstation (Hyprland + GNOME)
│   ├── server/             # Starter headless server (Docker + SSH)
│   └── nuc/                # Remote desktop mini PC (niri + DankMaterialShell, Sunshine over Tailscale)
├── modules/                # System-level modules (frost.* namespace)
│   ├── desktop/            # Window managers, desktop environments, display managers
│   ├── hardware/           # Audio (PipeWire), Bluetooth, Networking, Power
│   ├── oci/                # OCI containerized services (Jellyfin, Immich, pgAdmin)
│   ├── security/           # Polkit, PAM (U2F), SOPS-nix, 1Password
│   ├── services/           # Tailscale, SSH, Cloudflared, Syncthing, AdGuard
│   ├── storage/            # Disko, Btrfs rollback, Impermanence, ZFS
│   └── virtualization/     # MicroVM, Docker, Podman, Libvirt, Bottles
└── home/                   # User-level Home Manager modules (frost.home.* namespace)
    ├── home.nix            # Central user module collector
    ├── applications/       # 110+ granular app modules (dev, creative, shell, office)
    ├── configs/            # Managed configuration dotfiles (Hyprland, Kitty, Zsh, etc.)
    └── users/              # User profiles
        └── frost.nix       # Generic starter user environment
```

---

## 🚀 Getting Started

You can adopt Frost in two ways depending on your workflow:

### Option A: As a Starter Template (Fork & Clone)

Ideal if you want a complete, self-contained NixOS setup for your personal machines.

1. **Clone or fork this repository**:
   ```bash
   git clone https://github.com/SpanishSyntax/Frost.git ~/Frost
   cd ~/Frost
   ```

2. **Inspect and adjust starter configurations**:
   * [`hosts/workstation/`](hosts/workstation) — Pre-configured with Hyprland, GNOME, PipeWire, SDDM, and Disko NVMe partitioning.
   * [`hosts/server/`](hosts/server) — Pre-configured headless setup with Docker, OpenSSH, and standard Disko SATA partitioning.
   * [`hosts/nuc/`](hosts/nuc) — Intel NUC 13 Pro remote desktop: niri + DankMaterialShell, greetd auto-login, Sunshine with Intel VA-API encoding, Tailscale, and sleep disabled. See [Remote Desktop Host](#-remote-desktop-host-nuc).
   * [`home/users/frost.nix`](home/users/frost.nix) — Starter user dotfiles (Zsh, Starship, Neovim, Kitty, Git).

3. **Customize credentials**:
   In `hosts/workstation/users.nix`, change the initial password or add your SSH authorized keys:
   ```nix
   users.users.frost = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
     initialPassword = "your-password-here";
     # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
   };
   ```

4. **Build and switch**:
   ```bash
   # Test without modifying bootloader
   nixos-rebuild test --flake .#workstation

   # Switch permanently
   sudo nixos-rebuild switch --flake .#workstation
   ```

---

### Option B: As an External Flake Library (Private Fleet Architecture)

Ideal if you want to keep your personal configurations, encrypted secrets, and private hostnames in a separate private repository (e.g. `Glacier`) while pulling modules and updates from Frost.

Create a private repository with the following minimal `flake.nix`:

```nix
{
  description = "Personal Fleet Configuration";

  inputs = {
    frost.url = "github:SpanishSyntax/Frost";
    nixpkgs.follows = "frost/nixpkgs";
  };

  outputs = { self, frost, nixpkgs, ... } @ inputs: let
    inherit (frost.lib) mkSystem;
  in {
    nixosConfigurations = {
      my-laptop = mkSystem {
        host = "my-laptop";
        modules = [
          ./hosts/my-laptop/configuration.nix
        ];
        specialArgs = { inherit self; };
      };
    };
  };
}
```

In your host's `configuration.nix`, you have instant access to all `frost.*` system and user options with baseline system settings pre-injected:

```nix
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./users.nix
  ];

  frost = {
    desktop.wms.hyprland.enable = true;
    hardware.pipewire.enable = true;
    hardware.bluetooth.enable = true;
    security.polkit.enable = true;
    system.home_manager.enable = true;
  };
}
```

---

## 💿 Declarative Installation & Recovery

Frost packages declarative installer and recovery tools available as Flake apps:

### 1. `frost-install` — Automated Partitioning & Deployment

Runs [Disko](https://github.com/nix-community/disko) to partition and format disks, initializes persistent directory layouts (`/persist`), sets up host SSH keys, and installs NixOS:

```bash
# Install directly from the live installer image:
sudo nix run github:SpanishSyntax/Frost#install -- workstation

# Or from a local clone:
sudo nix run .#install -- workstation
```

> [!WARNING]
> Running `frost-install` will repartition and **format** the target drive declared in the host's `disko.nix`. Ensure your disk devices match your machine before proceeding.

### 2. `frost-recover` — Dynamic Rescue Mounting

Detects Btrfs root partitions (including LUKS-encrypted roots), automatically discovers historical root snapshots under `old_roots/`, mounts subvolumes (`@`, `@nix`, `@persist`, `@home`, `@boot`), and enters the environment:

```bash
# Auto-detects and mounts root filesystem to /mnt
sudo nix run github:SpanishSyntax/Frost#recover

# Enter the system environment
sudo nixos-enter
```

---

## 🖥️ Remote Desktop Host (NUC)

`hosts/nuc` turns a mini PC into a machine you stream from with [Moonlight](https://moonlight-stream.org) over Tailscale. It auto-logs `frost` into niri so Sunshine always has a session to capture, and it disables suspend so the box stays reachable.

```bash
sudo nix run .#install -- nuc          # formats /dev/nvme0n1 (unencrypted Btrfs)
```

After first boot (log in once locally or over SSH):

1. `sudo tailscale up` and approve the machine in your tailnet.
2. Open `https://<nuc-tailscale-name>:47990` from another tailnet device, create the Sunshine admin login.
3. In Moonlight, add the host by its Tailscale IP or MagicDNS name and enter the pairing PIN in the Sunshine web UI.

Notes:

* **No monitor attached?** The iGPU exposes no output to capture. Plug in an HDMI dummy plug (most reliable), or set `frost.services.sunshine.forceOutput = "HDMI-A-1";` to force the port on at boot.
* **Firewall:** Sunshine ports are not opened on the LAN; `tailscale0` is a trusted interface. Set `frost.services.sunshine.openFirewall = true` for LAN streaming.
* **Physical access:** auto-login means anyone at the keyboard gets the desktop. Lock it with `Mod+Alt+L` or enable DMS's idle lock.
* **Encryption:** the disk is unencrypted so the box can come back unattended after a power cut. Use the `workstation` LUKS layout instead if that trade-off doesn't suit you.
* **niri config:** `home/configs/niri/config.kdl` is DMS's recommended niri config with kitty as the terminal (`Mod+T`, launcher on `Mod+Space`). DMS writes its theme and keybind overrides to `~/.config/niri/dms/`.

---

## 🧩 Option Namespaces Overview

Frost utilizes a unified, predictable option hierarchy:

### System Options (`frost.*`)

| Namespace | Key Capabilities |
| :--- | :--- |
| `frost.desktop.wms` | `hyprland` (UWSM, Waybar, Caelestia integration), `niri` |
| `frost.desktop.des` | `gnome` |
| `frost.desktop.dms` | `sddm`, `greetd` (tuigreet, optional auto-login), `caelestia-greeter` |
| `frost.desktop.tools` | `caelestia`, `dank_material_shell` |
| `frost.hardware` | `pipewire`, `bluetooth`, `power`, `intel_graphics` (VA-API), `networking` (NetworkManager or Networkd) |
| `frost.security` | `pam` (YubiKey U2F), `sops_nix`, `polkit`, `gnome_keyring`, `onepassword` |
| `frost.services` | `ssh`, `tailscale`, `sunshine`, `wireguard`, `cloudflared`, `syncthing`, `adguard` |
| `frost.storage` | `disko`, `impermanence` (root-on-tmpfs), `btrfs_rollback`, `zfs` |
| `frost.virtualization` | `microvm` (declarative hypervisor guest VMs), `docker`, `podman`, `libvirt` |
| `frost.system` | `home_manager` (shared module injection), `keymap`, `autoTimezone` |

### User Options (`frost.home.apps.*`)

Over 110 modular application wrappers managed by Home Manager:

* **`ai`**: `antigravity`, `mcp_hub`, `n8n`, `opencode`
* **`creative`**: `blender`, `kdenlive`, `inkscape`, `obs`, `parabolic`, `sly`
* **`development`**: `git`, `nvim`, `flaker`, `heimdall`, `android_studio`, `vscode`, `zed`
* **`shell`**: `zsh`, `starship`, `bat`, `eza`, `fzf`, `kitty`, `tmux`, `zoxide`, `fastfetch`
* **`networking`**: `zen_browser`, `brave`, `tor`, `wireguard`, `openvpn`, `remmina`
* **`office`**: `libreoffice`, `onlyoffice`, `zotero`, `marktext`, `folio`, `todoist`
* **`system`**: `btop`, `ripgrep`, `thunar`, `pwvucontrol`, `sops`, `zip`

---

## ⚡ Dotfiles Hot-Reloading

Frost supports live editing of dotfiles without full NixOS rebuilding. When enabled, dotfiles are linked out-of-store via `mkOutOfStoreSymlink`:

```nix
frost.home = {
  dotfiles = {
    enableSymlinks = true;
    symlinkSourcePath = "/home/youruser/Frost/home/configs";
  };
};
```

Any edits made inside `home/configs/` (such as Hyprland keybinds, Waybar CSS, or Kitty themes) take effect immediately on reload without triggering `nixos-rebuild switch`.

---

## 🔐 Secrets Management

Frost does not store private credentials. When integrating secrets via [SOPS-nix](https://github.com/Mic92/sops-nix), all sensitive modules accept declarative, optional path inputs:

```nix
frost.security.sops_nix = {
  enable = true;
  defaultSopsFile = ./secrets/passwords.yaml;
};

frost.security.pam = {
  enable = true;
  sopsFile = ./secrets/pam.yaml;
};

frost.oci.jellyfin = {
  enable = true;
  sopsFile = ./secrets/services/jellyfin.yaml;
};
```

If `sopsFile` is omitted or set to `null`, secret extraction is cleanly bypassed, ensuring modules can still be evaluated and run in public or unencrypted environments.

---

## 📜 License

Licensed under the [MIT License](LICENSE) (or applicable project license). Contributions and improvements are welcome!

#!/usr/bin/env bash
set -euo pipefail

# Frost OS Declarative Installer

HOST="${1:-}"
FLAKE="${2:-.}"

if [ -z "${HOST}" ]; then
  echo "Usage: frost-install <host> [flake-uri]"
  echo ""
  echo "Available starter hosts in Frost:"
  echo "  - workstation"
  echo "  - server"
  echo "  - nuc"
  echo ""
  echo "Example:"
  echo "  frost-install workstation"
  echo "  frost-install workstation github:SpanishSyntax/Frost"
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: frost-install must be run as root (or via sudo)." >&2
  exit 1
fi

echo "=================================================="
echo " Frost OS Automated Installer"
echo " Target Host: ${HOST}"
echo " Flake URI:   ${FLAKE}"
echo "=================================================="
echo ""
echo "WARNING: This will repartition and FORMAT your target drive using Disko."
echo "All existing data on the target drive for '${HOST}' will be PERMANENTLY ERASED."
echo ""
read -r -p "Are you sure you want to continue? [y/N] " confirm
case "${confirm}" in
  [yY][eE][sS]|[yY])
    echo "Proceeding with installation..."
    ;;
  *)
    echo "Installation aborted."
    exit 0
    ;;
esac

# 1. Disko Partitioning and Formatting
echo "--> [1/4] Running Disko partitioning for ${HOST}..."
disko --mode disko --flake "${FLAKE}#${HOST}"

# 2. Setup Persistent Directories & Cryptographic Secrets
echo "--> [2/4] Setting up persistent storage layer and host identity..."
mkdir -p /mnt/persist/etc/ssh
mkdir -p /mnt/persist/etc/sops
mkdir -p /mnt/persist/etc/secrets/initrd

# Copy installer SSH host keys if present, or generate fresh ed25519 host key
if [ -f /etc/ssh/ssh_host_ed25519_key ]; then
  cp -r /etc/ssh/ssh_host_* /mnt/persist/etc/ssh/ 2>/dev/null || true
fi

if [ ! -f /mnt/persist/etc/ssh/ssh_host_ed25519_key ]; then
  echo "Generating fresh ed25519 host key..."
  ssh-keygen -t ed25519 -N "" -f /mnt/persist/etc/ssh/ssh_host_ed25519_key
fi

# Generate Dropbear initrd key for remote LUKS unlock
if [ ! -f /mnt/persist/etc/secrets/initrd/dropbear_ed25519_host_key ]; then
  echo "Generating Dropbear initrd unlock key..."
  dropbearkey -t ed25519 -f /mnt/persist/etc/secrets/initrd/dropbear_ed25519_host_key
fi

# Initialize SOPS identity stub if provided, or prepare empty file
if [ -n "${AGE_IDENTITY:-}" ]; then
  echo "${AGE_IDENTITY}" >/mnt/persist/etc/sops/identities.txt
  chmod 600 /mnt/persist/etc/sops/identities.txt
elif [ ! -f /mnt/persist/etc/sops/identities.txt ]; then
  touch /mnt/persist/etc/sops/identities.txt
  chmod 600 /mnt/persist/etc/sops/identities.txt
fi

echo "--------------------------------------------------"
echo " Your age public key for ${HOST} is:"
echo "--------------------------------------------------"
ssh-to-age < /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub
echo "--------------------------------------------------"

# 3. NixOS Installation
echo "--> [3/4] Installing NixOS via nixos-install..."
nixos-install --flake "${FLAKE}#${HOST}" --no-root-passwd

echo "=================================================="
echo "--> [4/4] Installation completed successfully!"
echo "You can now reboot into your new Frost OS system."
echo "=================================================="

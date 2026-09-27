{pkgs, ...}: {
  imports = [./home-manager.nix];
  programs.zsh.enable = true;

  # users.mutableUsers is false in Frost, so `passwd` changes are reverted on rebuild.
  # Replace with `hashedPassword = "<output of mkpasswd -m yescrypt>";` after first boot.
  users.users.root = {
    initialPassword = "changeme";
  };

  users.users.arpan = {
    isNormalUser = true;
    createHome = true;
    description = "Arpan";
    extraGroups = ["wheel" "networkmanager" "video" "audio" "docker"];
    shell = pkgs.zsh;
    initialPassword = "changeme";
  };
}

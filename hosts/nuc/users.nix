{pkgs, ...}: {
  imports = [./home-manager.nix];
  programs.zsh.enable = true;

  users.users.root = {
    initialPassword = "frost";
  };

  users.users.frost = {
    isNormalUser = true;
    createHome = true;
    description = "Frost Starter User";
    extraGroups = ["wheel" "networkmanager" "video" "audio"];
    shell = pkgs.zsh;
    initialPassword = "frost";
  };
}

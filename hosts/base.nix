{
  pkgs,
  inputs,
  stateVersion,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ../modules/modules.nix
  ];
  environment.systemPackages = with pkgs; [
    nix-tree # Great for auditing package bloat on the server
  ];

  system.stateVersion = stateVersion;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";
  nix.gc.randomizedDelaySec = "45min";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = ["root" "@wheel"];

    extra-substituters = [
      # "https://hyprland.cachix.org"
      "https://cache.flox.dev"
    ];
    extra-trusted-public-keys = [
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
    ];
  };

  users.mutableUsers = false;
}

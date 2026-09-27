{
  description = "Frost - Modular, Declarative NixOS Starter Framework";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iio-hyprland = {
      url = "github:commonkestrel/iio-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnw = {
      url = "github:Gerg-L/mnw";
    };

    caelestia = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell/v1.6.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    borealis = {
      url = "github:SpanishSyntax/Borealis";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flaker = {
      url = "github:SpanishSyntax/Flaker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    folio = {
      url = "github:SpanishSyntax/Folio";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    glaze = {
      url = "github:SpanishSyntax/Glaze";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astra-airlock = {
      url = "github:AstraSuite/Airlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    autofirma-nix.url = "github:nix-community/autofirma-nix/develop";

    flox = {
      url = "github:flox/flox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcp-hub-server = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: let
    inherit (inputs.nixpkgs) lib;
    stateVersion = "26.05";

    helpers = import ./lib/helpers {inherit lib inputs stateVersion;};
    inherit (helpers) mkSystem;
  in {
    lib = {
      inherit mkSystem;
      inherit (helpers) getFiles;
    };

    nixosModules = {
      default = {...}: {
        imports = [
          ./modules/modules.nix
          ./hosts/base.nix
          ./hosts/boot.nix
        ];
      };
      frost = inputs.self.nixosModules.default;
    };

    homeManagerModules = {
      default = ./home/home.nix;
      frost = inputs.self.homeManagerModules.default;
    };

    nixosConfigurations = {
      workstation = mkSystem {host = "workstation";};
      server = mkSystem {host = "server";};
      nuc = mkSystem {host = "nuc";};
    };

    packages.x86_64-linux = let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      installer = import ./installer {inherit pkgs inputs;};
    in {
      frost-install = installer.frostInstall;
      frost-recover = installer.frostRecover;
      default = installer.frostInstall;
    };

    apps.x86_64-linux = let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      installer = import ./installer {inherit pkgs inputs;};
    in {
      default = {
        type = "app";
        program = "${installer.frostInstall}/bin/frost-install";
      };
      install = {
        type = "app";
        program = "${installer.frostInstall}/bin/frost-install";
      };
      recover = {
        type = "app";
        program = "${installer.frostRecover}/bin/frost-recover";
      };
    };
  };
}

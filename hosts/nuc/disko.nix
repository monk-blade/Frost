{lib, ...}: {
  disko.devices = {
    disk = {
      main = {
        device = lib.mkDefault "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
                extraArgs = [
                  "-n"
                  "Nixos-boot"
                ];
              };
            };
            ROOT = {
              label = "root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "Nixos-root"
                  "-f"
                ];
                subvolumes = {
                  "@" = {
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/";
                  };
                  "@home" = {
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/home";
                  };
                  "@nix" = {
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/nix";
                  };
                  "@persist" = {
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/persist";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

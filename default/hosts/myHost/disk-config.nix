{ lib, pkgs, config, rootDisk, ... }:
{
  disko.devices = lib.mkIf config.custom.isDisko {
    disk = {
      disk0 = {
        type = "disk";
        device = config.custom.rootDisk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "nixos" "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "subvol=root"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "subvol=nix"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/swap" = lib.mkIf config.custom.isSwap {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = config.custom.swapSize;
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

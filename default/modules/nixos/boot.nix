{ config, lib, ... }:
{
  options.custom.boot = {
    systemd = lib.mkEnableOption "use systemd-boot";
  };

  config = {
    boot.loader = lib.mkIf config.custom.boot.systemd {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}

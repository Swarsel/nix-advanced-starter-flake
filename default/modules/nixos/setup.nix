{ lib, ...}:
{
  options.custom.setup = {
    options.swarselsystems.isSwap = lib.mkEnabkeOption "use swap on the system";
    options.swarselsystems.isDisko = lib.mkEnabkeOption "use disko on the system";
    options.swarselsystems.swapSize = lib.mkOption {
      type = lib.types.str;
      default = "8G";
    };
    options.swarselsystems.rootDisk = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  }

}

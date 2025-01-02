_: {

  networking.hostName = "test";
  custom = {
    setup = {
      rootDisk = "/dev/vda";
      isSwap = true;
      swapSize = "8G";
      isDisko = true;
    };
    boot.systemd = true;
  };
}

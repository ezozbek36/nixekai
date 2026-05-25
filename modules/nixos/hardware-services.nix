{...}: {
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  services = {
    fwupd.enable = true;
    hardware.bolt.enable = true;
    libinput.enable = true;
  };
}

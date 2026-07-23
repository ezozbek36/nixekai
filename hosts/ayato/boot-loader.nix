{ ... }: {
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 12;
    };
    efi.canTouchEfiVariables = true;
  };
}

{...}: {
  hardware.nvidia = {
    modesetting.enable = true;

    # Critical for battery: turns off dGPU when not in use
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    open = true;
    branch = "stable";
    nvidiaSettings = false;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      sync.enable = false;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
}

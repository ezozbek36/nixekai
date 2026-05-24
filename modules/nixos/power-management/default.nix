{...}: {
  imports = [
    ./tlp.nix
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  services.thermald.enable = true;
}

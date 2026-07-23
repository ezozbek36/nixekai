{ ... }: {
  imports = [
    ./intel.nix
    ./nvidia.nix
  ];

  services.switcherooControl.enable = true;
}

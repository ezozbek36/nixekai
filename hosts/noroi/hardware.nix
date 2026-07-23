{
  lib,
  config,
  inputs,
  modulesPath,
  ...
}:
{
  imports =
    [ ]
    ++ [ (modulesPath + "/installer/scan/not-detected.nix") ]
    ++ (with inputs.nixos-hardware.nixosModules; [ common-pc ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-pc-ssd ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-cpu-intel ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-gpu-intel ])
    ++ [ ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

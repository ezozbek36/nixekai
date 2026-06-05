{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = [];
    };

    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/94dbb0a1-44f1-45d7-85f4-6486b21a194c";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/94dbb0a1-44f1-45d7-85f4-6486b21a194c";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/94dbb0a1-44f1-45d7-85f4-6486b21a194c";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6898-E57A";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

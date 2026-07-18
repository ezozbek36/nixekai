{
  inputs,
  modulesPath,
  ...
}: {
  imports =
    []
    ++ [(modulesPath + "/installer/scan/not-detected.nix")]
    ++ (with inputs.nixos-hardware.nixosModules; [common-pc-laptop])
    ++ (with inputs.nixos-hardware.nixosModules; [common-pc-laptop-ssd])
    ++ [];

  hardware.facter.reportPath = ./facter.json;

  boot.kernelModules = ["msr"];

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
}

{
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
{
  imports =
    [ ]
    ++ (with inputs.intel-lpmd.nixosModules; [ default ])
    ++ [ "${modulesPath}/installer/scan/not-detected.nix" ]
    ++ (with inputs.nixos-hardware.nixosModules; [ common-cpu-intel ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-gpu-intel ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-pc-laptop ])
    ++ (with inputs.nixos-hardware.nixosModules; [ common-pc-laptop-ssd ])
    ++ [ ];

  hardware.facter.reportPath = ./facter.json;

  boot = {
    kernelParams = [ "iomem=relaxed" ];
    initrd.prepend = lib.singleton <| lib.toString <| pkgs.callPackage ./acpi-rp08-fix.nix { };
  };

  nixpkgs.overlays = lib.singleton (
    final: prev: {
      throttled =
        final.fetchurl {
          url = "https://raw.githubusercontent.com/ooonea/nixpkgs/refs/heads/throttled-0.12.2/pkgs/by-name/th/throttled/package.nix";
          hash = "sha256-d9uNtdrdxTWCv5IUNKoYcO2tBtCRQQOSw0j3WNhYP2o=";
        }
        |> (x: x.outPath)
        |> lib.flip final.callPackage { };
    }
  );

  services.throttled = {
    enable = true;
    extraConfig = lib.readFile ./throttled.conf;
  };

  services.irqbalance = {
    enable = true;
    package = pkgs.irqbalance.overrideAttrs (oldAttrs: {
      version = "1.9.5-unstable";
      src = pkgs.fetchFromGitHub {
        owner = "Irqbalance";
        repo = "irqbalance";
        rev = "16844fb60368ddc8aaf7750ca44f67cacf99e1ad";
        hash = "sha256-2rMIwuv20XGHHbK6FIQIHwNeXdYW49TfmLkhAQa/qSQ=";
      };
    });
  };

  systemd.services.irqbalance.wantedBy = [ "intel-lpmd.service" ];

  services.intel-lpmd = {
    debug = true;
    enable = true;
    config.custom = {
      filename = "intel_lpmd_config_F6_M186.xml";
      content = lib.readFile ./intel_lpmd_config_F6_M186.xml;
    };
  };

  systemd.services.intel-lpmd = {
    after = [ "irqbalance.service" ];
    wants = [ "irqbalance.service" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/94dbb0a1-44f1-45d7-85f4-6486b21a194c";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd:3"
        "noatime"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/94dbb0a1-44f1-45d7-85f4-6486b21a194c";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd:3"
        "noatime"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/94dbb0a1-44f1-45d7-85f4-6486b21a194c";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd:3"
        "noatime"
        "discard=async"
        "space_cache=v2"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6898-E57A";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [ ];
}

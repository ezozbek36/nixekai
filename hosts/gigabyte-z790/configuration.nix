{
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
  ];

  networking.hostId = "c9f175af";

  boot = {
    zfs.forceImportRoot = false;
    supportedFilesystems = ["zfs"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };

  services.openssh.enable = true;

  users.users.root.initialPassword = "123";
  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtUq3n5g7jBJtYCZ4jrePM21zo7FniQIpQLDpP9yqAe ezozbek@nixos"];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  system.stateVersion = "26.05";

  nix = {
    package = pkgs.lixPackageSets.stable.lix;

    settings = {
      auto-optimise-store = true;
      system-features = ["gccarch-raptorlake"];
      experimental-features = ["pipe-operator" "nix-command" "flakes"];
    };
  };
}

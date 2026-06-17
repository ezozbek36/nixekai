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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    kernelPackages = pkgs.linuxKernel.packagesFor pkgs.cachyosKernels.linux-cachyos-lts-lto-x86_64-v3;
  };

  services.openssh.enable = true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  system.stateVersion = "26.05";

  nix = {
    # package = pkgs.lixPackageSets.stable.lix;

    settings = {
      auto-optimise-store = true;
      trusted-users = ["builder"];
      system-features = ["gccarch-x86-64-v3"];
      experimental-features = ["pipe-operators" "nix-command" "flakes"];
      trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    };
  };

  networking.networkmanager.enable = true;

  users.users = {
    ezozbek = {
      isNormalUser = true;
      initialPassword = "123";
      extraGroups = ["networkmanager" "wheel"];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtUq3n5g7jBJtYCZ4jrePM21zo7FniQIpQLDpP9yqAe ezozbek@nixos"];
    };
    builder = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtUq3n5g7jBJtYCZ4jrePM21zo7FniQIpQLDpP9yqAe ezozbek@nixos"];
    };
  };
}

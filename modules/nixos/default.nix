{...}: {
  imports = [
    ./nix.nix
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./audio.nix
    ./bluetooth.nix
    ./power-management
    ./hardware-services.nix
    ./users.nix
    ./system-packages.nix
    ./desktop
    ./graphics
    ./environment.nix
    ./memory.nix
    ./sops.nix
    ./ssh.nix
    ./distributed-build.nix
    ./tty.nix
    ./kernel.nix
  ];
}

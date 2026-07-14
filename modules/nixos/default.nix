{...}: {
  imports = [
    ./networking.nix
    ./locale.nix
    ./audio.nix
    ./bluetooth.nix
    ./power-management
    ./hardware-services.nix
    ./system-packages.nix
    ./desktop
    ./graphics
    ./environment.nix
    ./memory.nix
    ./ssh.nix
    ./distributed-build.nix
  ];
}

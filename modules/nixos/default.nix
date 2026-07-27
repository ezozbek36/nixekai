{ ... }: {
  imports = [
    ./networking.nix
    ./locale.nix
    ./audio.nix
    ./system-packages.nix
    ./desktop
    ./graphics
    ./memory.nix
    ./distributed-build.nix
  ];
}

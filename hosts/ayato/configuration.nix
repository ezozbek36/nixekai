{
  inputs,
  ezModules,
  ...
}: {
  system.stateVersion = "25.11";

  imports =
    []
    ++ [./secrets.nix]
    ++ [./hardware.nix]
    ++ [./wireguard.nix]
    ++ [./boot-loader.nix]
    ++ [ezModules.cachyos-kernel]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ])
    ++ [];
}

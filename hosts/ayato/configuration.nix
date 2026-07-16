{
  inputs,
  ezModules,
  ...
}: {
  system.stateVersion = "25.11";

  imports =
    []
    ++ [./hm.nix]
    ++ [./misc.nix]
    ++ [./users.nix]
    ++ [./secrets.nix]
    ++ [./hardware.nix]
    ++ [./wireguard.nix]
    ++ [./boot-loader.nix]
    ++ [ezModules.cachyos-kernel]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-intel
      common-pc-laptop
      common-pc-laptop-ssd
    ])
    ++ [];
}

{ezModules, ...}: {
  system.stateVersion = "26.05";

  imports =
    []
    ++ [./sshd.nix]
    ++ [./users.nix]
    ++ [./disko.nix]
    ++ [./secrets.nix]
    ++ [./hardware.nix]
    ++ [./wireguard.nix]
    ++ [./networking.nix]
    ++ [./boot-loader.nix]
    ++ [ezModules.cachyos-kernel]
    ++ [];

  nix = {
    settings = {
      system-features = ["gccarch-x86-64-v3"];
    };
  };
}

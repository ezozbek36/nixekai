{ezModules, ...}: {
  system.stateVersion = "26.05";

  imports =
    []
    ++ [./sshd.nix]
    ++ [./users.nix]
    ++ [./disko.nix]
    ++ [./secrets.nix]
    ++ [./hardware.nix]
    ++ [ezModules.avahi]
    ++ [./networking.nix]
    ++ [./boot-loader.nix]
    ++ [ezModules.cachyos-kernel]
    ++ [ezModules.wireguard-spoke]
    ++ [];

  nix = {
    settings = {
      system-features = ["gccarch-x86-64-v3"];
    };
  };
}

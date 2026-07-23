{ezModules, ...}: {
  system.stateVersion = "25.11";

  imports =
    []
    ++ [./hm.nix]
    ++ [./misc.nix]
    ++ [./users.nix]
    ++ [./secrets.nix]
    ++ [./hardware.nix]
    ++ [ezModules.avahi]
    ++ [ezModules.gaming]
    ++ [./boot-loader.nix]
    ++ [ezModules.cachyos-kernel]
    ++ [ezModules.wireguard-spoke]
    ++ [];
}

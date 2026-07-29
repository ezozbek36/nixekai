{ ezModules, ... }: {
  system.stateVersion = "25.11";

  imports =
    [ ]
    ++ [ ./hm.nix ]
    ++ [ ./misc.nix ]
    ++ [ ./users.nix ]
    ++ [ ./secrets.nix ]
    ++ [ ezModules.ssh ]
    ++ [ ezModules.tpm2 ]
    ++ [ ./hardware.nix ]
    ++ [ ezModules.fwupd ]
    ++ [ ./networking.nix ]
    ++ [ ezModules.gaming ]
    ++ [ ./boot-loader.nix ]
    ++ [ ezModules.cachyos-kernel ]
    ++ [ ];
}

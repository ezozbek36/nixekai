{ ezModules, ... }: {
  system.stateVersion = "26.05";

  imports =
    [ ]
    ++ [ ./sshd.nix ]
    ++ [ ./users.nix ]
    ++ [ ./disko.nix ]
    ++ [ ./secrets.nix ]
    ++ [ ./hardware.nix ]
    ++ [ ezModules.tpm2 ]
    ++ [ ./networking.nix ]
    ++ [ ./boot-loader.nix ]
    ++ [ ezModules.cachyos-kernel ]
    ++ [ ];

  nix = {
    settings = {
      system-features = [ "gccarch-x86-64-v3" ];
    };
  };
}

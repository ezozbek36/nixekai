{ ezModules, ... }: {
  system.stateVersion = "23.06";

  imports =
    [ ]
    ++ [ ./sshd.nix ]
    ++ [ ./disko.nix ]
    ++ [ ./users.nix ]
    ++ [ ./3proxy.nix ]
    ++ [ ./secrets.nix ]
    ++ [ ./hardware.nix ]
    ++ [ ./networking.nix ]
    ++ [ ./boot-loader.nix ]
    ++ [ ezModules.wireguard-hub ]
    ++ [ ];
}

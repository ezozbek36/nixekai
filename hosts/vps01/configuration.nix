{ ... }: {
  system.stateVersion = "23.06";

  imports =
    [ ]
    ++ [ ./knot.nix ]
    ++ [ ./sshd.nix ]
    ++ [ ./disko.nix ]
    ++ [ ./hydra.nix ]
    ++ [ ./users.nix ]
    ++ [ ./secrets.nix ]
    # ++ [ ./3proxy.nix ]
    ++ [ ./hardware.nix ]
    ++ [ ./networking.nix ]
    ++ [ ./boot-loader.nix ]
    ++ [ ];
}

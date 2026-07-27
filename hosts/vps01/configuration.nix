{ ... }: {
  system.stateVersion = "23.06";

  imports =
    [ ]
    ++ [ ./sshd.nix ]
    ++ [ ./disko.nix ]
    ++ [ ./users.nix ]
    ++ [ ./secrets.nix ]
    # ++ [ ./3proxy.nix ]
    ++ [ ./hardware.nix ]
    ++ [ ./networking.nix ]
    ++ [ ./boot-loader.nix ]
    ++ [ ];
}

{ ... }: {
  system.stateVersion = "23.06";

  imports =
    [ ]
    ++ [ ./sshd.nix ]
    ++ [ ./caddy.nix ]
    ++ [ ./disko.nix ]
    ++ [ ./hydra.nix ]
    ++ [ ./users.nix ]
    ++ [ ./nixbot.nix ]
    ++ [ ./secrets.nix ]
    # ++ [ ./3proxy.nix ]
    ++ [ ./postgres.nix ]
    ++ [ ./hardware.nix ]
    ++ [ ./networking.nix ]
    ++ [ ./boot-loader.nix ]
    ++ [ ];
}

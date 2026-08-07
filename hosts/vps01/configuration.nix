{
  lib,
  config,
  inputs,
  ...
}:
{
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

  nixpkgs.overlays = lib.singleton (
    final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        config = config.nixpkgs.config;
        system = config.nixpkgs.hostPlatform.system;
      };
    }
  );
}

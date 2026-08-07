{
  config,
  inputs,
  ezModules,
  ...
}:
{
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
    ++ [ ezModules.remote-builders ]
    # ++ [ ezModules.cachyos-kernel ]
    ++ [ ];

  # programs.nix-data = {
  #   enable = true;
  #   hostname = "ayato";
  #   flake = "/home/ezozbek/nix/flake.nix";
  # };

  sops.secrets."ssh_keys/eu.nixbuild.net" = {
    owner = "ezozbek";
    group = "users";
  };

  ezConfigs.remote-builders = {
    enable = false;
    useBuildersSubstitutes = true;
    builders = {
      "eu.nixbuild.net" = {
        maxJobs = 100;
        sshUser = "builder";
        system = "x86_64-linux";
        privateKeyFile = config.sops.secrets."ssh_keys/eu.nixbuild.net".path;
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
        extraSSHConfig = {
          ServerAliveInterval = "60";
          PubkeyAcceptedKeyTypes = "ssh-ed25519";
        };
      };
    };
  };
}

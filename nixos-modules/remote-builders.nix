{
  lib,
  config,
  ...
}:
let
  cfg = config.ezConfigs.remote-builders;

  builderSubmodule = lib.types.submodule {
    options = {
      system = lib.mkOption {
        type = lib.types.str;
        default = "x86_64-linux";
        description = "System type of the remote builder.";
      };

      maxJobs = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Maximum number of concurrent build jobs.";
      };

      speedFactor = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Speed factor for build job scheduling priority.";
      };

      protocol = lib.mkOption {
        type = lib.types.enum [
          "ssh"
          "ssh-ng"
        ];
        default = "ssh-ng";
        description = "Protocol to use for connecting to the builder.";
      };

      sshUser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SSH user for connecting to the builder.";
      };

      supportedFeatures = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of supported Nix features.";
      };

      publicKey = lib.mkOption {
        type = lib.types.str;
        description = "SSH host public key for the builder.";
      };

      privateKeyFile = lib.mkOption {
        type = lib.types.str;
        description = "Path to the SSH private key file for connecting to the builder.";
      };

      extraSSHConfig = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Extra SSH config options for this builder's Host block.";
        example = {
          PubkeyAcceptedKeyTypes = "ssh-ed25519";
          ServerAliveInterval = "60";
        };
      };
    };
  };
in
{
  options.ezConfigs.remote-builders = {
    enable = lib.mkEnableOption "Remote Nix build machines";

    useBuildersSubstitutes = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether remote builders should use substitutes.";
    };

    builders = lib.mkOption {
      type = lib.types.attrsOf builderSubmodule;
      default = { };
      description = "Attribute set of remote builders keyed by hostname.";
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      distributedBuilds = true;
      settings.builders-use-substitutes = cfg.useBuildersSubstitutes;
      buildMachines =
        cfg.builders
        |> lib.mapAttrsToList (
          hostName: builder:
          {
            inherit hostName;
            inherit (builder)
              protocol
              system
              maxJobs
              speedFactor
              supportedFeatures
              ;
          }
          // lib.optionalAttrs (builder.sshUser != null) {
            inherit (builder) sshUser;
          }
        );
    };

    programs.ssh = {
      knownHosts =
        cfg.builders
        |> lib.mapAttrs (
          hostName: builder: {
            hostNames = [ hostName ];
            inherit (builder) publicKey;
          }
        );
      extraConfig =
        cfg.builders
        |> lib.mapAttrsToList (
          hostName: builder:
          let
            lines =
              (lib.singleton "  IdentityFile ${builder.privateKeyFile}")
              ++ (builder.extraSSHConfig |> lib.mapAttrsToList (key: value: "  ${key} ${value}"));
          in
          ''
            Host ${hostName}
            ${lines |> lib.concatStringsSep "\n"}
          ''
        )
        |> lib.concatStringsSep "\n";
    };
  };
}

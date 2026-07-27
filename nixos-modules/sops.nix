{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkMerge [
    {
      sops = {
        validateSopsFiles = true;

        age = {
          plugins = lib.mkIf config.security.tpm2.enable [ pkgs.age-plugin-tpm ];
          generateKey = !config.security.tpm2.enable || !config.services.openssh.enable;
          keyFile =
            if config.security.tpm2.enable then
              "/var/lib/sops-nix/tpm-key.txt"
            else
              "/var/lib/sops-nix/key.txt";
          sshKeyPaths =
            lib.optionals config.services.openssh.enable config.services.openssh.hostKeys
            |> lib.filter (key: key.type == "ed25519")
            |> lib.map (key: key.path);
        };
      };
    }
    (lib.mkIf config.security.tpm2.enable {
      assertions = [
        {
          assertion = config.sops.useSystemdActivation;
          message = "A userborn service is required";
        }
      ];

      systemd.services.sops-install-secrets = {
        after = [ "generate-tpm-age-key.service" ];
        wants = [ "generate-tpm-age-key.service" ];
      };

      systemd.services.generate-tpm-age-key = {
        description = "Generate TPM-sealed age identity for sops-nix";
        wantedBy = [ "sysinit.target" ];
        before = [ "sops-install-secrets.service" ];
        after = [ "dev-tpmrm0.device" ];
        unitConfig = {
          DefaultDependencies = "no";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart =
            let
              escapedKeyFile = lib.escapeShellArg config.sops.age.keyFile;
            in
            /* bash */ ''
              if [[ ! -f ${escapedKeyFile} ]]; then
                mkdir -p $(dirname ${escapedKeyFile})
                ${pkgs.age-plugin-tpm}/bin/age-plugin-tpm --generate -o ${escapedKeyFile}
              fi
            ''
            |> pkgs.writeShellScript "generate-tpm-age-key";
        };
      };
    })
  ];
}

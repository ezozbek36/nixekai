{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.default];

  sops = {
    validateSopsFiles = true;

    secrets.wireguard_peer1 = { sopsFile = ../../secrets/wireguard.yaml; };

    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = config.services.openssh.hostKeys |> lib.filter (key: key.type == "ed25519") |>  lib.map (key: key.path);
    };
  };
}

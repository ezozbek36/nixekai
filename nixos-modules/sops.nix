{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.default];

  sops = {
    validateSopsFiles = true;

    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = lib.optionals config.services.openssh.enable config.services.openssh.hostKeys |> lib.filter (key: key.type == "ed25519") |> lib.map (key: key.path);
    };
  };
}

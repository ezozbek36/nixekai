{
  ezModules,
  ...
}: {
  imports = [ezModules.sops];

  sops = {
    defaultSopsFile = ./secrets.yaml;

    secrets.wireguard = {};
  };
}

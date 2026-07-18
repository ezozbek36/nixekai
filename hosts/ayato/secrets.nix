{ezModules, ...}: {
  imports = [ezModules.sops];

  sops = {
    defaultSopsFile = ./secrets.yaml;

    secrets.wireguard = {};
    secrets.wakatime_api_key = { owner = "ezozbek"; };
  };
}

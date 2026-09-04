{ config, inputs, ... }:
{
  imports = with inputs.hydra.nixosModules; [ hydra ];

  nix.package = config.services.hydra-dev.package.nix;

  services = {
    hydra-dev = {
      enable = true;
      useSubstitutes = true;
      listenHost = "127.0.0.1";
      hydraURL = "https://hydra.ezozbek.dev";
      notificationSender = "hydra@localhost";
      dbUrl = "postgres://hydra@127.0.0.1:5432/hydra";
      extraConfig = ''
        <git-input>
          timeout = 3600
        </git-input>
      '';
    };
    caddy.virtualHosts."hydra.ezozbek.dev" = {
      extraConfig = ''
        reverse_proxy http://${config.services.hydra-dev.listenHost}:${toString config.services.hydra-dev.port}
      '';
    };
  };
}

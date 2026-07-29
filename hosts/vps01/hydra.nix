{ config, ... }: {
  services = {
    hydra = {
      enable = true;
      maxServers = 4;
      minSpareServers = 2;
      maxSpareServers = 4;
      useSubstitutes = true;
      listenHost = "localhost";
      hydraURL = "https://hydra.ezozbek.dev";
      notificationSender = "hydra@localhost";
      extraConfig = ''
        <git-input>
          timeout = 3600
        </git-input>
      '';
    };
    caddy.virtualHosts."hydra.ezozbek.dev" = {
      extraConfig = ''
        reverse_proxy http://${config.services.hydra.listenHost}:${toString config.services.hydra.port}
      '';
    };
  };
}

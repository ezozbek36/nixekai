{
  lib,
  config,
  topology,
  ...
}:
{
  networking = {
    firewall.allowedUDPPorts = [ topology.port ];
    networkmanager.unmanaged = lib.mkIf config.networking.networkmanager.enable [
      "interface-name:wg0"
    ];
  };

  sops.secrets.wireguard = {
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  systemd = {
    services.systemd-networkd = lib.mkIf config.sops.useSystemdActivation {
      after = [ "sops-install-secrets.service" ];
      wants = [ "sops-install-secrets.service" ];
    };

    network = {
      enable = true;
      wait-online.enable = false;
      networks."50-wg0" = {
        matchConfig.Name = "wg0";
        address = [ "${topology.spokes.${config.networking.hostName}.tunnelIP}/24" ];
      };
      netdevs."50-wg0" = {
        netdevConfig = {
          Name = "wg0";
          MTUBytes = 1320;
          Kind = "wireguard";
        };
        wireguardConfig = {
          ListenPort = topology.port;
          PrivateKeyFile = config.sops.secrets.wireguard.path;
        };
        wireguardPeers = [
          {
            PersistentKeepalive = 20;
            AllowedIPs = [ topology.subnet ];
            PublicKey = topology.hub.publicKey;
            Endpoint = "${topology.hub.endpoint}:${toString topology.port}";
          }
        ];
      };
    };
  };
}

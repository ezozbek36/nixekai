{
  config,
  topology,
  ...
}: {
  sops.secrets.wireguard = {
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  systemd.network = {
    enable = true;
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = ["${topology.spokes.${config.networking.hostName}.tunnelIP}/24"];
    };
    netdevs."50-wg0" = {
      netdevConfig = {
        Name = "wg0";
        MTUBytes = 1420;
        Kind = "wireguard";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets.wireguard.path;
      };
      wireguardPeers = [
        {
          PersistentKeepalive = 25;
          AllowedIPs = [topology.subnet];
          PublicKey = topology.hub.publicKey;
          Endpoint = "${topology.hub.endpoint}:${toString topology.port}";
        }
      ];
    };
  };
}

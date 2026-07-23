{
  lib,
  config,
  topology,
  ...
}: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;
  
  sops.secrets.wireguard = {
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [topology.port];

  systemd.network = {
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = ["${topology.hub.tunnelIP}/24"];
      networkConfig = {
        IPv4Forwarding = true;
      };
    };
    netdevs."50-wg0" = {
      netdevConfig = {
        Name = "wg0";
        MTUBytes = 1420;
        Kind = "wireguard";
      };
      wireguardConfig = {
        ListenPort = topology.port;
        PrivateKeyFile = config.sops.secrets.wireguard.path;
      };
      wireguardPeers =
        topology.spokes
        |> lib.mapAttrsToList (name: spoke: {
          PublicKey = spoke.publicKey;
          AllowedIPs = ["${spoke.tunnelIP}/32"];
        });
    };
  };
}

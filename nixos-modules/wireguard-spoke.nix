{
  lib,
  config,
  topology,
  ...
}:
{
  nixpkgs.overlays = lib.singleton (import ../overlays/amneziawg-latest.nix);

  sops.secrets.wireguard = {
    mode = "0640";
  };

  networking = {
    firewall.allowedUDPPorts = [ topology.port ];
    networkmanager.unmanaged = lib.mkIf config.networking.networkmanager.enable [
      "interface-name:wg0"
    ];
    wg-quick.interfaces.wg0 = {
      type = "amneziawg";
      listenPort = topology.port;
      privateKeyFile = config.sops.secrets.wireguard.path;
      address = [ "${topology.spokes.${config.networking.hostName}.tunnelIP}/24" ];
      peers = [
        {
          persistentKeepalive = 20;
          allowedIPs = [ topology.subnet ];
          publicKey = topology.hub.publicKey;
          endpoint = "${topology.hub.endpoint}:${toString topology.port}";
        }
      ];
    };
  };
}

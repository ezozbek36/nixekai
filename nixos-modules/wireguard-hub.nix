{
  lib,
  config,
  topology,
  ...
}:
{
  nixpkgs.overlays = lib.singleton (import ../overlays/amneziawg-latest.nix);

  boot.kernel.sysctl."net.ipv4.ip_forward" = true;

  sops.secrets.wireguard = {
    mode = "0640";
    reloadUnits = [ "wg-quick-wg0.service" ];
    restartUnits = [ "wg-quick-wg0.service" ];
  };

  networking = {
    firewall.allowedUDPPorts = [ topology.port ];
    wg-quick.interfaces.wg0 = {
      type = "amneziawg";
      listenPort = topology.port;
      address = [ "${topology.hub.tunnelIP}/24" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      peers =
        topology.spokes
        |> lib.mapAttrsToList (
          name: spoke: {
            persistentKeepalive = 20;
            publicKey = spoke.publicKey;
            allowedIPs = [ "${spoke.tunnelIP}/32" ];
          }
        );
    };
  };
}

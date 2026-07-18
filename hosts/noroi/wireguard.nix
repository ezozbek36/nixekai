{
  lib,
  config,
  ...
}: {
  networking = rec {
    firewall.allowedUDPPorts = wireguard.interfaces |> lib.mapAttrsToList (name: value: value.listenPort);
    wireguard.interfaces.wg0 = {
      listenPort = 51820;

      ips = ["100.64.0.3/24"];

      privateKeyFile = config.sops.secrets.wireguard.path;

      peers = [
        {
          allowedIPs = ["100.64.0.1"];
          endpoint = "185.203.117.165:51820";
          publicKey = "Kuhsa2PEVGEZpII6zpwH9sZWrU9HXiTjNsb3euLSTgU=";
          persistentKeepalive = 25;
        }
        {
          allowedIPs = ["100.64.0.2"];
          endpoint = "185.203.117.165:51820";
          publicKey = "RK3PNvpCQTEDUvKWR+TOmSq0VyoqDlTIP1bQ0zQpO1w=";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

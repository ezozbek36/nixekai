{
  lib,
  pkgs,
  config,
  ...
}: let
  write-iptables = type: ip: ''
    ${pkgs.iptables}/bin/iptables -t nat -${type} POSTROUTING -s ${ip} -o ${config.networking.nat.externalInterface} -j MASQUERADE
  '';
in {
  networking = rec {
    nat = {
      enable = true;
      externalInterface = "ens18";
      internalInterfaces = lib.attrNames wireguard.interfaces;
    };
    firewall.allowedUDPPorts = wireguard.interfaces |> lib.mapAttrsToList (name: value: value.listenPort);
    wireguard.interfaces.wg0 = rec {
      listenPort = 51820;

      ips = ["100.64.0.1/24"];

      privateKeyFile = config.sops.secrets.wireguard.path;

      postSetup = ips |> lib.map (ip: ip |> write-iptables "D");
      postShutdown = ips |> lib.map (ip: ip |> write-iptables "A");

      peers = [
        {
          allowedIPs = ["100.64.0.2/32"];
          publicKey = "RK3PNvpCQTEDUvKWR+TOmSq0VyoqDlTIP1bQ0zQpO1w=";
        }
        {
          allowedIPs = ["100.64.0.3/32"];
          publicKey = "fLSjRP+k/Dee1HQ6mGtlvnvycGHpcM1pdvVWl/E+SSQ=";
        }
      ];
    };
  };
}

{ ezModules, ... }: {
  imports = [ ezModules.wireguard-hub ];

  networking = {
    useDHCP = false;
    useNetworkd = true;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
    defaultGateway = {
      address = "185.203.117.1";
      interface = "ens18";
    };

    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "185.203.117.165";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a07:5741:0:842::1";
          prefixLength = 64;
        }
      ];
    };
  };
}

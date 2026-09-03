{ ... }: rec {
  networking = {
    networkmanager = {
      dns = "systemd-resolved";
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      Domains = [ "~." ];
      MulticastDNS = true;
      FallbackDNS = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
    };
  };
}

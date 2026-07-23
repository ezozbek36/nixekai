{ ... }: rec {
  services._3proxy = {
    enable = true;
    usersFile = "/etc/3proxy.passwd";
    services = [
      {
        type = "socks";
        bindPort = 1080;
        auth = [ "strong" ];
        acl = [
          {
            rule = "allow";
            users = [ "ezozbek" ];
          }
        ];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = services._3proxy.services |> map (service: service.bindPort);

  environment.etc."3proxy.passwd".text = ''
    ezozbek:CR:$1$2JbeTWNL$WXwQ3H/ykbzG3UagFikLA1
  '';
}

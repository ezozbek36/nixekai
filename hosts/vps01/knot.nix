{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = with inputs.tangled.nixosModules; [ knot ];

  services = {
    tangled.knot = rec {
      enable = true;
      git.userName = "git";
      stateDir = "/var/lib/tangled-knot";
      repo.scanPath = "${stateDir}/repos";
      server = {
        listenAddr = "127.0.0.1:5555";
        hostname = "knot1.ezozbek.dev";
        owner = "did:plc:qdb2cht3jucz5y6we2wz556k";
      };
    };
    caddy = {
      enable = true;
      virtualHosts."knot1.ezozbek.dev" = {
        extraConfig = ''
          reverse_proxy http://${config.services.tangled.knot.server.listenAddr} {
            header_down X-Real-IP {http.request.remote}
            header_down X-Forwarded-For {http.request.remote}
          }
        '';
      };
    };
    openssh.settings = {
      AllowUsers = lib.singleton config.services.tangled.knot.git.userName;
      AllowGroups = lib.singleton config.services.tangled.knot.git.userName;
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}

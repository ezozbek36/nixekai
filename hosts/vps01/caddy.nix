{ pkgs, config, ... }: {
  networking.firewall.allowedTCPPorts = [ 443 ];

  sops.secrets.caddy = {
    format = "dotenv";
    sopsFile = ./caddy.env;
  };

  services.caddy = {
    enable = true;
    environmentFile = config.sops.secrets.caddy.path;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-PWadA5qr/gR2qDcT8l8u1Xku7LM2HIfWTLOkzezCYy0=";
    };
    virtualHosts."*.ezozbek.dev" = {
      extraConfig = ''
        tls {
          dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        }
      '';
    };
  };
}

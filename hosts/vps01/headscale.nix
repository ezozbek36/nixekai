{
  lib,
  config,
  ...
}: let
  domain = "ezozbek.dev";
in {
  services.headscale = {
    enable = true;

    settings = {
      server_url = "https://tail.${domain}";
      database = {
        type = "sqlite3";
      };
      prefixes = {
        allocation = "random";
      };
      dns = {
        magic_dns = true;
        override_local_dns = false;
        base_domain = "vpn.${domain}";
      };
    };
  };

  services.caddy = {
    enable = true;
    openFirewall = true;
    virtualHosts = let
      headscale_url = config.services.headscale.settings.server_url;
    in {
      "${headscale_url |> lib.replaceString "https" "http"}" = {
        extraConfig = ''
          # Tailscale captive portal detection
          handle /generate_204 {
              respond 204
          }

          handle * {
              redir https://{host}{uri}
          }
        '';
      };
      "${headscale_url |> lib.replaceString "https://" ""}" = {
        logFormat = lib.mkForce "output discard";
        extraConfig = ''
          reverse_proxy ${config.services.headscale.address}:${toString config.services.headscale.port} {
            header_up True-Client-IP {remote_host}
            header_up X-Real-IP {remote_host}
          }
        '';
      };
    };
  };
}

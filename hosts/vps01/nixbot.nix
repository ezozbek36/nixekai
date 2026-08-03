{ config, inputs, ... }:
{
  imports = with inputs.nixbot.nixosModules; [ nixbot ];

  sops.secrets.codeberg_token = { };
  sops.secrets.codeberg_nix_bot_secret = { };

  services = {
    nixbot = {
      enable = true;
      useHTTPS = true;
      nginx.enable = false;
      domain = "nixbot.ezozbek.dev";
      admins = [ "gitea:ezozbek36" ];
      buildSystems = [ "x86_64-linux" ];

      evalWorkerCount = 1;
      evalMaxMemorySize = 1024;

      database = {
        createLocally = false;
        url = "postgresql:///nixbot?host=/run/postgresql";
      };

      gitea = {
        enable = true;
        instanceUrl = "https://codeberg.org";

        tokenFile = config.sops.secrets.codeberg_token.path;

        oauthId = "c5133f4a-1eb2-44d7-b9e7-ecab0b25dc52";
        oauthSecretFile = config.sops.secrets.codeberg_nix_bot_secret.path;
      };
    };

    caddy.virtualHosts."${config.services.nixbot.domain}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.nixbot.port}
      '';
    };
  };
}

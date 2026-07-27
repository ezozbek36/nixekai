{ ezModules, ... }: {
  imports = [ ezModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;

    secrets."access_tokens/github.com" = { };

    secrets.wakatime_api_key = {
      owner = "ezozbek";
    };
  };
}

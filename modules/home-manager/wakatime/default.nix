{
  pkgs,
  nixosConfig,
  ...
}:
let
  ini = pkgs.formats.ini { };
in
{
  imports = [ ./targets.nix ];

  home.file.".wakatime.cfg".source = ini.generate ".wakatime.cfg" {
    settings = {
      api_key_vault_cmd = "${pkgs.coreutils}/bin/cat ${nixosConfig.sops.secrets.wakatime_api_key.path}";
    };
  };
}

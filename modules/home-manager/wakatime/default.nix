{ pkgs, ... }: let
  ini = pkgs.formats.ini {};
in {
  imports = [./targets.nix];

  home.file.".wakatime.cfg".source = ini.generate ".wakatime.cfg" {
    settings = {
      api_key = "waka_47cabe18-e24e-4cc8-a485-a9edaaa6971b";
    };
  };
}

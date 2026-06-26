{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  config = lib.mkMerge [
    (lib.mkIf config.programs.zen-browser.enable {
      programs.zen-browser.profiles.default = {
        extensions = {
          packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [wakatimes];
        };
      };
    })
    (lib.mkIf config.programs.zed-editor.enable {
      programs.zed-editor.extraPackages = with pkgs; [wakatime-cli];
    })
    (lib.mkIf config.programs.zed-editor-extensions.enable {
      programs.zed-editor-extensions.packages = with pkgs.zed-extensions; [wakatime];
    })
  ];
}

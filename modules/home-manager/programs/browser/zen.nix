{
  pkgs,
  # firefox-addons,
  ...
}:
{
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    profiles.default = {
      # extensions = with firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [bitwarden-password-manager];
    };
  };
}

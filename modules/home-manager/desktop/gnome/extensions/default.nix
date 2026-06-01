{pkgs, ...}: let
  copyous = pkgs.callPackage ./copyous.nix {};

  extensions = with pkgs.gnomeExtensions;
    [
      runcat
      user-themes
      appindicator
      dash-to-dock
      blur-my-shell
    ]
    ++ [copyous];
in {
  home.packages = extensions;

  # Export for use in dconf settings
  _module.args.gnomeExtensionsList = extensions;
}

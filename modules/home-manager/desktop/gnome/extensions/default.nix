{pkgs, ...}: {
  home.packages = with pkgs.gnomeExtensions; [
    runcat
    copyous
    user-themes
    appindicator
    dash-to-dock
    blur-my-shell
  ];
}

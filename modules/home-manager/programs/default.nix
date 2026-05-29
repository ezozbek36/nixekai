{pkgs, ...}: {
  imports = [
    ./git.nix
    ./browser
    ./matrix.nix
    ./element.nix
    ./spotify.nix
    ./fastfetch.nix
    ./telegram-desktop.nix
  ];

  home.packages = with pkgs; [d-spy];
}

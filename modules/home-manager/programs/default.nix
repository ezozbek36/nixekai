{pkgs, ...}: {
  imports = [
    ./git.nix
    ./browser
    ./element.nix
    ./spotify.nix
    ./fastfetch.nix
    ./telegram-desktop.nix
  ];

  home.packages = with pkgs; [d-spy];
}

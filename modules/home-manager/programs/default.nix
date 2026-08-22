{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./browser
    ./matrix.nix
    ./spotify.nix
    ./discord.nix
    ./fastfetch.nix
    ./telegram-desktop.nix
  ];

  home.packages = with pkgs; [ d-spy ];
}

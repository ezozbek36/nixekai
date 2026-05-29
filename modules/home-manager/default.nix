# Home Manager configuration
{...}: {
  home = {
    username = "ezozbek";
    homeDirectory = "/home/ezozbek";
    preferXdgDirectories = true;
  };

  imports = [
    ./stylix.nix
    ./shell
    ./terminal
    ./programs
    ./desktop
    ./editor
    ./services
    ./fonts.nix
  ];

  # Home Manager Version
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

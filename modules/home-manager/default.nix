# Home Manager configuration
{...}: {
  home = {
    username = "ezozbek";
    preferXdgDirectories = true;
    homeDirectory = "/home/ezozbek";
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
    # ./wakatime
  ];

  # Home Manager Version
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.tailscale-systray.enable = true;
}

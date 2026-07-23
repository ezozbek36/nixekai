{
  pkgs,
  config,
  ...
}:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${pkgs.hyprland}/share/wayland-sessions --remember --remember-user-session";
      };
    };
  };
}

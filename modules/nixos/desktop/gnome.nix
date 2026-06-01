{pkgs, ...}: {
  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling', 'autoclose-xwayland']
    '';
  };

  environment.systemPackages = with pkgs; [resources];

  environment = {
    gnome.excludePackages = with pkgs; [
      totem
      epiphany
      gnome-tour
      gnome-music
      gnome-console
      gnome-system-monitor
    ];

    variables = {
      __GL_SYNC_TO_VBLANK = 0;
      CLUTTER_PAINT = "disable-clipped-redraws:disable-culling";
    };
  };
}

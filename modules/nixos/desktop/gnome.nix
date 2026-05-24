{pkgs, ...}: {
  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling', 'autoclose-xwayland']
    '';
  };

  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-console
      epiphany
      gnome-tour
      gnome-music
      totem
    ];

    variables = {
      __GL_SYNC_TO_VBLANK = 0;
      CLUTTER_PAINT = "disable-clipped-redraws:disable-culling";
    };
  };
}

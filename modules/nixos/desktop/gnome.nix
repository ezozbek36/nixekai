{ lib, pkgs, ... }: {
  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['autoclose-xwayland']
    '';
  };

  environment.systemPackages = with pkgs.unstable; [ mission-center ];

  services.udev.extraRules = ''
    SUBSYSTEM=="powercap" KERNEL=="intel-rapl*" ACTION=="add", \
      RUN+="${lib.getExe' pkgs.coreutils "chgrp"} -R wheel /sys/%p/'", \
      RUN+="${lib.getExe' pkgs.coreutils "chmod"} -R g+r /sys/%p/"
  '';

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

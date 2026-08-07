{ lib, pkgs, ... }: {
  nixpkgs.overlays = lib.singleton (
    final: prev: {
      mission-center =
        final.fetchurl {
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/dc4be957075ee6a0e61465291cf36df49c565ff1/pkgs/by-name/mi/mission-center/package.nix";
          hash = "sha256-WB8QqUnc/wDwxhFRxoGz1tw2qzMdX4LJfeErQBPipnk=";
        }
        |> (x: x.outPath)
        |> lib.flip final.callPackage { };
    }
  );

  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['autoclose-xwayland']
    '';
  };

  environment.systemPackages = with pkgs; [ mission-center ];

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

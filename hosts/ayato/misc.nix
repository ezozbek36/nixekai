{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ ../../modules/nixos ] ++ [ inputs.relago.nixosModules.relago ];

  environment.systemPackages = with pkgs; [ disko ];

  services.relago = {
    enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.ccache.enable = true;

  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];

  services.udev.extraRules = ''
    ATTRS{idVendor}=="0e8d", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="04e8", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="18d1", ENV{ID_MM_DEVICE_IGNORE}="1"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", TAG+="uaccess"
    KERNEL=="ttyACM*", MODE="0666", TAG+="uaccess"
  '';

  virtualisation.podman.enable = true;
  virtualisation.oci-containers = {
    backend = "podman";
    containers.openqa = {
      autoStart = true;
      image = "registry.opensuse.org/devel/openqa/containers/openqa-single-instance:latest";
      ports = [
        "127.0.0.1:1080:80"
        "127.0.0.1:1443:443"
      ];
      volumes = [
        "/var/lib/openqa/share:/var/lib/openqa/share"
        "/var/lib/openqa/pgsql:/var/lib/pgsql"
      ];
      extraOptions = [ "--device=/dev/kvm" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/openqa 0755 root root -"
    "d /var/lib/openqa/share 0755 root root -"
    "d /var/lib/openqa/pgsql 0755 root root -"
  ];

  nixpkgs = {
    overlays = [
      inputs.spicetify-nix.overlays.default
      inputs.zed-extensions.overlays.default
      inputs.mac-style-plymouth.overlays.default
      (
        final: prev:
        let
          system = final.stdenv.hostPlatform.system;
        in
        {
          tuigreet = inputs.tuigreet.packages.${system}.default;

          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config = config.nixpkgs.config;
          };

          uchar-desktop = inputs.uchar.packages.${pkgs.stdenv.hostPlatform.system}.desktop;
        }
      )
    ]
    # ++ (import ../../overlays)
    ;
    config.permittedInsecurePackages = [
      "olm-3.2.16"
    ];
    config.allowUnfreePredicate =
      pkg:
      let
        isFirmware =
          if pkg.meta ? sourceProvenance then
            builtins.elem lib.sourceTypes.binaryFirmware pkg.meta.sourceProvenance
          else
            builtins.elem (lib.getName pkg) [ "facetimehd-firmware" ];
      in
      isFirmware
      || builtins.elem (lib.getName pkg) [
        "nvidia-kernel-modules"
        "intel-ocl"
        "android-studio"
        "rust-rover"
        "clion"
        "spotify"
        "steam"
        "steam-unwrapped"
        "discord"
      ];
  };
}

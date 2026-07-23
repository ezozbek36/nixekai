{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ ../../modules/nixos ];

  nixpkgs = {
    overlays = [
      inputs.spicetify-nix.overlays.default
      inputs.zed-extensions.overlays.default
      inputs.nix-cachyos-kernel.overlays.default
      inputs.mac-style-plymouth.overlays.default
      inputs.hyprland.overlays.hyprland-packages
      (
        final: prev:
        let
          system = prev.stdenv.hostPlatform.system;
        in
        {
          tuigreet = inputs.tuigreet.packages.${system}.default;
          hyprlandPlugins = (prev.hyprlandPlugins or { }) // {
            hyprspace = inputs.hyprspace.packages.${system}.default;
          };

          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config = config.nixpkgs.config;
          };
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
      ];
  };
}

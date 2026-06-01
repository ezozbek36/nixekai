{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-parts.url = "github:hercules-ci/flake-parts";

    json-schema = {
      url = "github:ezozbek36/nix-json-schema";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    relago = {
      url = "github:xinux-org/relago";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    tuigreet = {
      url = "github:NotAShelf/tuigreet/0.10.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zed-extensions = {
      url = "github:DuskSystems/nix-zed-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uchar = {
      url = "git+https://git.oss.uzinfocom.uz/uchar/cross?ref=refs/pull/62/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "path:/home/ezozbek/OpenSource/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.55.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs @ {
    self,
    uchar,
    stylix,
    relago,
    nixpkgs,
    hyprland,
    sops-nix,
    zen-browser,
    json-schema,
    flake-parts,
    home-manager,
    spicetify-nix,
    zed-extensions,
    nix-cachyos-kernel,
    mac-style-plymouth,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        devShells.default = import ./shell.nix self {inherit pkgs;};
      };
      flake = {
        # NixOS configuration
        nixosConfigurations.swift-sfx14-71g = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ({lib, ...}: {
              nixpkgs.overlays =
                [
                  uchar.overlays.default
                  spicetify-nix.overlays.default
                  zed-extensions.overlays.default
                  nix-cachyos-kernel.overlays.pinned
                  mac-style-plymouth.overlays.default
                  hyprland.overlays.hyprland-packages
                  (final: prev: let
                    system = prev.stdenv.hostPlatform.system;
                  in {
                    tuigreet = inputs.tuigreet.packages.${system}.default;
                    hyprlandPlugins =
                      (prev.hyprlandPlugins or {})
                      // {
                        hyprspace = inputs.hyprspace.packages.${system}.default;
                      };
                  })
                ]
                ++ (import ./overlays);
              nixpkgs.config.permittedInsecurePackages = [
                "olm-3.2.16"
              ];
              nixpkgs.config.allowUnfreePredicate = pkg: let
                isFirmware =
                  if pkg.meta ? sourceProvenance
                  then builtins.elem lib.sourceTypes.binaryFirmware pkg.meta.sourceProvenance
                  else builtins.elem (lib.getName pkg) ["facetimehd-firmware"];
              in
                isFirmware || builtins.elem (lib.getName pkg) ["intel-ocl" "rust-rover" "clion" "spotify" "steam" "steam-unwrapped"];
            })

            ./hosts/swift-sfx14-71g/configuration.nix

            sops-nix.nixosModules.sops

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs;};
                users.ezozbek = import ./modules/home-manager;
                sharedModules = [
                  uchar.homeModules.default
                  stylix.homeModules.stylix
                  zen-browser.homeModules.beta
                  json-schema.homeModules.default
                  zed-extensions.homeManagerModules.default
                  spicetify-nix.homeManagerModules.spicetify
                ];
              };
            }

            # relago.nixosModules.default
            # {
            #   services.relago.enable = true;
            # }
          ];
        };
      };
    };
}

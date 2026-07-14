{
  description = "NixOS configuration with Home Manager";

  inputs = {
    systems.url = "github:nix-systems/x86_64-linux";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
      };
    };

    disko = {
      url = "github:nix-community/disko/v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
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

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };

    ez-configs = {
      url = "path:/home/ezozbek/OpenSource/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    json-schema = {
      url = "github:ezozbek36/nix-json-schema";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    tuigreet = {
      url = "github:NotAShelf/tuigreet/0.10.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zed-extensions = {
      url = "github:DuskSystems/nix-zed-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    spicetify-nix = {
      url = "github:ezozbek36/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.55.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
      };
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs = {
        systems.follows = "systems";
        hyprland.follows = "hyprland";
      };
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      # imports = [inputs.ez-configs.flakeModule];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        devShells.default = import ./shell.nix inputs.self {inherit pkgs;};
        devShells.kernelConfig = pkgs.mkShell {
          packages = with pkgs; [
            gcc
            flex
            bison
          ];
        };
      };

      # ezConfigs = rec {
      #   root = ./.;
      #   globalArgs = { inherit inputs; };

      #   nixos = {
      #     configurationsDirectory = "${root}/hosts";
      #     configurationEntryPoint = "configuration.nix";

      #     hosts = {
      #       ayato = {
      #         arch = "x86_64";
      #         class = "nixos";
      #       };
      #       noroi = {
      #         arch = "x86_64";
      #         class = "nixos";
      #       };
      #       vps01 = {
      #         arch = "x86_64";
      #         class = "nixos";
      #       };
      #     };
      #   };
      # };

      flake = let
        ezModules = {
          nix = ./nixos-modules/nix.nix;
          kmscon = ./nixos-modules/kmscon.nix;
          cachyos-kernel = ./nixos-modules/cachyos-kernel.nix;
        };
      in {
        nixosConfigurations.vps01 = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [./hosts/vps01/configuration.nix];
        };
        nixosConfigurations.ayato = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs ezModules;};
          modules = [
            {
              networking.hostName = "ayato";
            }
            ({
              lib,
              config,
              ...
            }: {
              nixpkgs.overlays =
                [
                  inputs.spicetify-nix.overlays.default
                  inputs.zed-extensions.overlays.default
                  inputs.nix-cachyos-kernel.overlays.default
                  inputs.mac-style-plymouth.overlays.default
                  inputs.hyprland.overlays.hyprland-packages
                  (final: prev: let
                    system = prev.stdenv.hostPlatform.system;
                  in {
                    tuigreet = inputs.tuigreet.packages.${system}.default;
                    hyprlandPlugins =
                      (prev.hyprlandPlugins or {})
                      // {
                        hyprspace = inputs.hyprspace.packages.${system}.default;
                      };

                    unstable = import inputs.nixpkgs-unstable {
                      inherit system;
                      config = config.nixpkgs.config;
                    };

                    assimp = prev.assimp.overrideAttrs (old: {
                      NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -ffp-contract=on";
                    });

                    pythonPackagesExtensions =
                      prev.pythonPackagesExtensions
                      ++ [
                        (py-final: py-prev: {
                          distutils = py-prev.distutils.overridePythonAttrs (oldAttrs: {
                            disabledTestPaths = (oldAttrs.disabledTestPaths or []) ++ ["distutils/tests"];
                          });
                        })
                      ];
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
                isFirmware || builtins.elem (lib.getName pkg) ["nvidia-kernel-modules" "intel-ocl" "android-studio" "rust-rover" "clion" "spotify" "steam" "steam-unwrapped"];
              nixpkgs.hostPlatform.system = "x86_64-linux";
              nixpkgs.hostPlatform.gcc = {
                arch = "x86-64-v3";
                tune = "generic";
              };
            })

            ./hosts/ayato/configuration.nix
            ./modules/nixos/default.nix
            ./nixos-modules/cachyos-kernel.nix

            inputs.sops-nix.nixosModules.sops

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs;};
                users.ezozbek = import ./modules/home-manager;
                sharedModules = [
                  inputs.stylix.homeModules.stylix
                  inputs.zen-browser.homeModules.beta
                  inputs.json-schema.homeModules.default
                  inputs.zed-extensions.homeManagerModules.default
                  inputs.spicetify-nix.homeManagerModules.spicetify
                ];
              };
            }
          ];
        };
        nixosConfigurations.noroi = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs ezModules;};
          modules = [
            ./hosts/noroi/configuration.nix
            {
              nixpkgs = {
                overlays = [
                  inputs.nix-cachyos-kernel.overlays.default
                ];
                hostPlatform.system = "x86_64-linux";
                hostPlatform.gcc = {
                  arch = "x86-64-v3";
                  tune = "generic";
                };
              };
            }
          ];
        };
      };
    };

  nixConfig = {
    extra-substituters = [
      "ssh-ng://builder@10.10.1.223"
    ];
    extra-trusted-public-keys = [
      "builder@10.10.1.223:f/5cKP/gqo0I5jjAIuR1TSgxtdHlrg4vJe+cE8LrkMA="
    ];
  };
}

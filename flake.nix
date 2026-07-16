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
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: {
      systems = import inputs.systems;
      imports = [inputs.ez-configs.flakeModule];
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

      ezConfigs = rec {
        root = ./.;
        globalArgs = {inherit inputs;};

        nixos = {
          configurationsDirectory = "${root}/hosts";
          configurationEntryPoint = "configuration.nix";

          hosts = {
            ayato = {
              arch = "x86_64";
              class = "nixos";
              tags = ["lix" "fprint" "laptop" "performance-v3"];
            };
            noroi = {
              arch = "x86_64";
              class = "nixos";
              tags = ["lix" "performance-v3"];
            };
            vps01 = {
              arch = "x86_64";
              class = "nixos";
            };
          };
        };

        perClass = class: ezModules: {
          modules = [] ++ lib.optionals (class == "nixos") [ezModules.nix];
        };

        perTag = tag: ezModules: {
          modules =
            []
            ++ lib.optionals (tag == "fprint") [ezModules.fingerprint]
            ++ lib.optionals (tag == "performance-v3") [ezModules.performance-v3]
            ++ lib.optionals (tag == "laptop") [ezModules.openrgb ezModules.power-management]
            ++ lib.optionals (tag == "lix") [
              {
                nix.implementation = "lix";
                nix.patchLixPipeOperator = true;
              }
            ];
        };
      };
    });

  nixConfig = {
    extra-substituters = [
      "ssh-ng://builder@10.10.1.223"
    ];
    extra-trusted-public-keys = [
      "builder@10.10.1.223:f/5cKP/gqo0I5jjAIuR1TSgxtdHlrg4vJe+cE8LrkMA="
    ];
  };
}

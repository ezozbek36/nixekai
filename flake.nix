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

    tangled = {
      url = "git+https://tangled.org/ezozbek.tngl.sh/tangled-core";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        gomod2nix.inputs = {
          flake-utils.follows = "flake-utils";
          falke-utils.inputs.systems.follows = "systems";
        };
      };
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }: {
        systems = import inputs.systems;
        imports = [ inputs.ez-configs.flakeModule ];
        perSystem = { pkgs, ... }: {
          formatter = pkgs.nixfmt;

          devShells.default = import ./shell.nix inputs.self { inherit pkgs; };
        };

        ezConfigs = rec {
          root = ./.;
          globalArgs = { inherit inputs; };

          nixos = {
            configurationsDirectory = "${root}/hosts";
            configurationEntryPoint = "configuration.nix";

            earlyModuleArgs = {
              topology = {
                port = 51820;
                subnet = "100.64.0.0/24";

                hub = {
                  tunnelIP = "100.64.0.1";
                  endpoint = "185.203.117.165";
                  publicKey = "pZoJJXulyj9gjmNgBN9rQvWpI7WPl8Q2RGWNGpmtZik=";
                };

                spokes = {
                  ayato = {
                    tunnelIP = "100.64.0.2";
                    publicKey = "8EV3QAkb8XOcgY5t1I2gQDL8iTcreRNzXM8JZhwj6Sg=";
                  };
                  noroi = {
                    tunnelIP = "100.64.0.3";
                    publicKey = "EUXMM9c6Hgsh4X/b//BFQ7JxutNfrD08f5WI8J/FWzI=";
                  };
                  android = {
                    tunnelIP = "100.64.0.4";
                    publicKey = "Eo/5YTwml+oIEXFRNWqjNT2Kv596xAJ7ZDc2K9q01A4=";
                  };
                };
              };
            };

            hosts = {
              ayato = {
                arch = "x86_64";
                class = "nixos";
                tags = [
                  "lix"
                  "laptop"
                ];
              };
              noroi = {
                arch = "x86_64";
                class = "nixos";
                tags = [ "lix" ];
              };
              vps01 = {
                arch = "x86_64";
                class = "nixos";
              };
            };
          };

          perClass = class: ezModules: {
            modules =
              [ ] ++ [ ezModules.bluetoth ] ++ lib.optionals (class == "nixos") [ ezModules.nix ] ++ [ ];
          };

          perTag = tag: ezModules: {
            modules =
              [ ]
              ++ lib.optionals (tag == "performance-v3") [ ezModules.performance-v3 ]
              ++ lib.optionals (tag == "laptop") [
                ezModules.openrgb
                ezModules.power-management
              ]
              ++ lib.optionals (tag == "lix") [
                {
                  nix.implementation = "lix";
                  nix.patchLixPipeOperator = true;
                }
              ]
              ++ [ ];
          };
        };
      }
    );

  # nixConfig = {
  #   extra-substituters = [
  #     "ssh-ng://builder@10.10.1.223"
  #   ];
  #   extra-trusted-public-keys = [
  #     "builder@10.10.1.223:f/5cKP/gqo0I5jjAIuR1TSgxtdHlrg4vJe+cE8LrkMA="
  #   ];
  # };
}

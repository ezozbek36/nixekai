{
  description = "NixOS configuration with Home Manager";

  inputs = {
    systems.url = "github:nix-systems/x86_64-linux";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs-unstable";
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
      url = "github:ezozbek36/stylix/release-26.05";
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
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
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
      url = "github:ezozbek36/ez-configs/refactor";
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

    hydra = {
      url = "github:NixOS/hydra";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    intel-lpmd = {
      url = "github:dmfrpro/intel-lpmd-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gram-editor = {
      url = "https://raw.githubusercontent.com/mikaeladev/home-manager/e6738a65f0dafdc80be4299cdec8e09bb955b2dc/modules/programs/gram.nix";
      flake = false;
    };

    nixbot = {
      url = "github:Mic92/nixbot";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "nixpkgs";
      };
    };

    nix-data = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/nix-data?shallow=1&ref=main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        git-hooks.follows = "git-hooks";
        treefmt-nix.follows = "treefmt-nix";
        xinux-lib.inputs = {
          git-hooks.follows = "git-hooks";
          treefmt-nix.follows = "treefmt-nix";
          flake-parts.follows = "flake-parts";
          flake-compat.follows = "flake-compat";
          flake-utils-plus.inputs = {
            flake-utils.follows = "flake-utils";
          };
        };
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }: {
        systems = import inputs.systems;
        imports = with inputs; [
          git-hooks.flakeModule
          ez-configs.flakeModule
          treefmt-nix.flakeModule
        ];
        perSystem =
          {
            pkgs,
            config,
            system,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs-unstable { inherit system; };

            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                nixfmt.enable = true;
                yamlfmt.enable = true;
                jsonfmt.enable = true;
              };
            };

            pre-commit = {
              check.enable = true;
              settings = {
                package = pkgs.prek;
                hooks = {
                  treefmt.enable = true;
                };
              };
            };

            devShells.default = import ./shell.nix { inherit pkgs config; };

            packages.riff = pkgs.callPackage ./packages/riff.nix { };
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
                spokePort = 443;
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
            modules = [ ezModules.bluetoth ] ++ lib.optionals (class == "nixos") [ ezModules.nix ];
          };

          perTag = tag: ezModules: {
            modules =
              lib.optionals (tag == "performance-v3") [ ezModules.performance-v3 ]
              ++ lib.optionals (tag == "laptop") [
                ezModules.openrgb
                ezModules.power-management
              ]
              ++ lib.optionals (tag == "lix") [
                {
                  nix.implementation = "lix";
                  nix.patchLixPipeOperator = true;
                }
              ];
          };
        };
      }
    );

  nixConfig = {
    extra-substituters = [
      "https://cache.xinux.uz"
    ];
    extra-trusted-public-keys = [
      "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    ];
  };
}

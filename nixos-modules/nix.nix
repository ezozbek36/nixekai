{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  options.nix.implementation = lib.mkOption {
    default = "nix";
    type = lib.types.enum [
      "nix"
      "lix"
    ];
  };

  options.nix.patchLixPipeOperator = lib.mkEnableOption "Lix feature flag name parity";

  options.nix.pinRegistries = lib.mkEnableOption "Whether pin flake registries/channels" // {
    default = true;
  };

  options.nix.includeAccessTokens =
    lib.mkEnableOption "Whether include access tokens from sops templates"
    // {
      default =
        config.sops.secrets
        |> lib.filterAttrs (name: value: lib.match "^access_tokens/.+$" name != null)
        |> lib.attrNames
        |> lib.length
        |> (x: x > 0);
    };

  config = lib.mkMerge [
    (lib.mkIf (config.nix.patchLixPipeOperator) {
      nixpkgs.overlays = [
        (final: prev: {
          lixPackageSets = prev.lixPackageSets.extend (
            f: p:
            let
              applyOverride = scopeFinal: scopePrev: {
                lix = scopePrev.lix.overrideAttrs (oldAttrs: {
                  prePatch = (oldAttrs.prePatch or "") + ''
                    mv lix/libutil/experimental-features/pipe-operator.md lix/libutil/experimental-features/pipe-operators.md
                    substituteInPlace lix/libutil/meson.build tests/unit/libexpr/trivial.cc lix/libutil/experimental-features/pipe-operators.md \
                      --replace-fail 'pipe-operator' 'pipe-operators'
                  '';
                });
              };
            in
            {
              git = p.git.overrideScope applyOverride;
              lix_2_94 = p.lix_2_94.overrideScope applyOverride;
              lix_2_95 = p.lix_2_95.overrideScope applyOverride;
            }
          );
        })
      ];
    })
    (lib.mkIf (config.nix.pinRegistries) {
      nix.registry =
        lib.mkForce inputs
        |> lib.filterAttrs (name: lib.isType "flake")
        |> lib.mapAttrs (name: value: { flake = value; });
      nix.nixPath = config.nix.registry |> lib.mapAttrsToList (name: value: "${name}=flake:${name}");
      nix.settings.flake-registry = "/etc/nix/registry.json";
    })
    (lib.mkIf (config.nix.includeAccessTokens) {
      sops.templates."nix-access-tokens.conf" = {
        restartUnits = [ "nix-daemon.service" ];
        content = ''
          access-tokens = ${
            config.sops.secrets
            |> lib.filterAttrs (name: value: lib.match "^access_tokens/.+$" name != null)
            |> lib.mapAttrsToList (
              name: value: "${name |> lib.splitString "/" |> lib.last}=${config.sops.placeholder.${name}}"
            )
            |> lib.concatStringsSep ","
          }
        '';
      };

      nix.extraOptions = ''
        !include ${config.sops.templates."nix-access-tokens.conf".path}
      '';
    })
    {
      nix = {
        package =
          if config.nix.implementation == "nix" then
            lib.mkDefault pkgs.nix
          else if config.nix.implementation == "lix" then
            pkgs.lixPackageSets.latest.lix
          else
            throw "Unknown nix implementation specified: ${config.nix.implementation}";

        settings = {
          trusted-users = [ "@wheel" ];

          auto-optimise-store = true;
          experimental-features = [
            "flakes"
            "nix-command"
            (
              if config.nix.implementation == "lix" && !config.nix.patchLixPipeOperator then
                "pipe-operator"
              else
                "pipe-operators"
            )
          ];

          substituters = [ "https://cache.xinux.uz" ];
          trusted-public-keys = [ "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0=" ];
        };
      };
    }
  ];
}

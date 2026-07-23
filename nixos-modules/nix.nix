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
        inputs
        |> lib.filterAttrs (name: lib.isType "flake")
        |> lib.mapAttrs (name: value: { flake = value; });
      nix.nixPath = config.nix.registry |> lib.mapAttrsToList (name: value: "${name}=flake:${name}");
      nix.settings.flake-registry = "/etc/nix/registry.json";
    })
    {
      nix = {
        package =
          if config.nix.implementation == "nix" then
            pkgs.nix
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

          substituters = [ "https://cache.xinux.uz?priority=100" ];
          trusted-public-keys = [ "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0=" ];
        };
      };
    }
  ];
}

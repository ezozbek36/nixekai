{pkgs, ...}: {
  nix = {
    package = pkgs.lixPackageSets.stable.lix.overrideAttrs (oldAttrs: rec {
      prePatch =
        (oldAttrs.prePatch or "")
        + ''
          mv lix/libutil/experimental-features/pipe-operator.md lix/libutil/experimental-features/pipe-operators.md
          substituteInPlace lix/libutil/meson.build tests/unit/libexpr/trivial.cc lix/libutil/experimental-features/pipe-operators.md \
            --replace-fail 'pipe-operator' 'pipe-operators'
        '';
    });

    settings = {
      trusted-users = ["ezozbek"];

      auto-optimise-store = true;
      experimental-features = ["pipe-operators" "nix-command" "flakes"];

      substituters = ["https://cache.xinux.uz?priority=100"];
      trusted-public-keys = [
        "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
      ];
    };
  };
}

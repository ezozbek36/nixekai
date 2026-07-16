{...}: {
  nixpkgs = {
    hostPlatform = {
      system = "x86_64-linux";
      gcc.arch = "x86-64-v3";
      gcc.tune = "generic";
    };
    overlays = [
      (final: prev: {
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
    ];
  };
}

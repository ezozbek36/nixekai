{ lib, ... }: {
  nixpkgs.overlays = lib.singleton (
    final: prev: {
      fwupd = prev.fwupd.overrideAttrs (oldAttrs: rec {
        version = "2.1.7";
        src = final.fetchFromGitHub {
          owner = "fwupd";
          repo = "fwupd";
          tag = version;
          hash = "sha256-TkF6Bdg4iFnjlLnRysU2+jXlfpg/3yN/hugntaI2xYE=";
        };

        patches = oldAttrs.patches |> lib.filter (patch: lib.baseNameOf patch != "0004-Get-the-efi-app-from-fwupd-efi.patch");
      });
    }
  );

  services.fwupd.enable = true;
}

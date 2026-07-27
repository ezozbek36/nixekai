{ lib, pkgs, ... }: {
  nixpkgs.overlays = lib.singleton (
    final: prev: {
      tpm2-pkcs11 = prev.tpm2-pkcs11.overrideAttrs (oldAttrs: {
        configureFlags = (oldAttrs.configureFlags or [ ]) ++ [ "--enable-fapi=no --with-fapi=no" ];
      });
    }
  );

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  environment.systemPackages = with pkgs; [ tpm2-tools ];
}

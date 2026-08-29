{ pkgs, config, ... }:
pkgs.mkShellNoCC {
  inherit (config.pre-commit) shellHook;

  buildInputs = with pkgs; [
    nixd
    statix
    deadnix
    alejandra

    age
    sops
    opensc
    ssh-to-age
    acpica-tools
    age-plugin-tpm
  ];
}

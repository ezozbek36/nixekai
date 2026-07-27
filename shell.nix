flake:
{ pkgs, ... }:
pkgs.mkShellNoCC {
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
    wireguard-tools
  ];
}

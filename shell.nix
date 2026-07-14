flake: {pkgs, ...}:
pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    nixd
    statix
    deadnix
    alejandra

    age
    sops
    ssh-to-age
    wireguard-tools
  ];
}

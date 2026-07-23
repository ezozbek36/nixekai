{ ... }: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3 --keep-since 3d";
    flake = "$HOME/nix";
  };
}

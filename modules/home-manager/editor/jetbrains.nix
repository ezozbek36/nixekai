{ pkgs, ... }: {
  home.packages =
    with pkgs;
    [
      jetbrains.rust-rover
      jetbrains.clion
    ]
    ++ [
      pkgs.unstable.android-studio
    ];
}

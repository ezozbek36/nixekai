{ pkgs, ... }: {
  home.packages = with pkgs.unstable; [ android-studio ];
}

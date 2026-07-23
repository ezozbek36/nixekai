{ pkgs, ... }: {
  home.packages = with pkgs.unstable; [
    telegram-desktop
  ];
}

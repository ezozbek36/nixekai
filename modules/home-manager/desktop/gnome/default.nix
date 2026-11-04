{ pkgs, ... }: {
  imports = [
    ./dconf
    ./extensions
  ];

  home.packages = with pkgs; [ forge-sparks ];
}

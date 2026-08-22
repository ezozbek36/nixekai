{ lib, pkgs, ... }: {
  home.packages =
    lib.singleton
    <| pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    };
}

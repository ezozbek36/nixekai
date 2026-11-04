{
  lib,
  inputs,
  modulesPath,
  ...
}:
{
  disabledModules = lib.singleton "${modulesPath}/config/console.nix";

  imports = lib.singleton "${inputs.nixpkgs-unstable}/nixos/modules/config/console.nix";

  i18n.imperativeLocale = true;
  time.timeZone = "Asia/Tashkent";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [
    "ru_RU.UTF-8/UTF-8"
    "uz_UZ.UTF-8/UTF-8"
  ];
}

{ ezModules, ... }: {
  imports = [ ezModules.dns-resolved ] ++ [ ];

  networking.networkmanager.enable = true;
}

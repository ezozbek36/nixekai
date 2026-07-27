{ ezModules, ... }: {
  imports = [ ezModules.dns-resolved ] ++ [ ezModules.wireguard-spoke ];

  networking.networkmanager.enable = true;
}

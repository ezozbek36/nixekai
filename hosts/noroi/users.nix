{ pkgs, config, ... }: {
  programs.zsh.enable = true;

  services.userborn.enable = true;

  sops.secrets."users_passwd/ezozbek" = { };

  users = {
    defaultUserShell = pkgs.zsh;
    users = rec {
      ezozbek = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."users_passwd/ezozbek".path;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        openssh.authorizedKeys.keys = [
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCzYNs/SnPVAopjHnPmPQYoOubuZGq8rC9olk+s6EelCykm/xjJHWjXuf9Cl1FGXY/80UKD5qkfveM3kiAMCU2Q= ayato > noroi"
        ];
      };
      builder = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = ezozbek.openssh.authorizedKeys.keys;
      };
    };
  };
}

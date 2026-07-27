{ pkgs, config, ... }: {
  programs.zsh.enable = true;

  sops.secrets."users_passwd/ezozbek" = { };

  users = {
    defaultUserShell = pkgs.zsh;
    users = rec {
      root.openssh.authorizedKeys.keys = ezozbek.openssh.authorizedKeys.keys;
      ezozbek = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        hashedPasswordFile = config.sops.secrets."users_passwd/ezozbek".path;
        openssh.authorizedKeys.keys = [
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBF16uS/uNuHJpnk4BtZI/eB5Mmtl9EgVxYJLWe2xbh38ZPTlndsySvMwwoeILW9PavrOWsIQ1HhoC2adykSECAE= ayato > vps01"
        ];
      };
    };
  };
}

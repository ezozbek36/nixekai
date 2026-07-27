{ lib, config, ... }:
{
  config = lib.mkMerge [
    (lib.mkIf (config.security.tpm2.enable && config.security.tpm2.pkcs11.enable) {
      services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

      programs.ssh = {
        startAgent = true;
        enableAskPassword = true;
        agentPKCS11Whitelist = "/run/current-system/sw/lib/*,/nix/store/*/lib/*";
        extraConfig = ''
          PKCS11Provider /run/current-system/sw/lib/libtpm2_pkcs11.so
        '';
      };

      security.pam.sshAgentAuth.enable = true;
    })
  ];
}

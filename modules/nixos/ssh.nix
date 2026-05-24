{config, ...}: {
  programs.ssh = {
    knownHosts = {
      nixbuild = {
        hostNames = ["eu.nixbuild.net"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
      uzinfocom = {
        hostNames = ["ns3.oss.uzinfocom.uz"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINNOqMshb7i/Oo08Y5XvgExuyTLlbV27roxU+pkF8n9l";
      };
      kolyma = {
        hostNames = ["ns3.kolyma.uz"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEX2HbpS/5iXk+Huq/Rw0KkgO19yIabrd/k+hf9g5L+s";
      };
    };

    extraConfig = ''
      Host eu.nixbuild.net
        PubkeyAcceptedKeyTypes ssh-ed25519
        ServerAliveInterval 60
        IPQoS throughput
        IdentityFile ${config.users.users.ezozbek.home}/.ssh/my-nixbuild-key

      Host ns3.oss.uzinfocom.uz
        User builder
        Port 22
        IdentityFile ${config.users.users.ezozbek.home}/.ssh/my-nixbuild-key

      Host ns3.kolyma.uz
        User builder
        Port 22
        IdentityFile ${config.users.users.ezozbek.home}/.ssh/my-nixbuild-key
    '';
  };
}

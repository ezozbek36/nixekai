{config, ...}: {
  programs.ssh = {
    knownHosts = {
      nixbuild = {
        hostNames = ["eu.nixbuild.net"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
      uzinfocom = {
        hostNames = ["ns3.oss.uzinfocom.uz"];
        publicKey = "ns3.oss.uzinfocom.uz ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINNOqMshb7i/Oo08Y5XvgExuyTLlbV27roxU+pkF8n9l";
      };
      kolyma = {
        hostNames = ["ns3.kolyma.uz"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALR9Xxei/ghvXwIfeFF4K0rsVQr7EP3ygUtPm26WCLp";
      };
      noroi = {
        hostNames = ["10.10.1.223"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILbGxcfZflt2/DSx/24eJP0DvA5NoexqsExLDzc9hs84";
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

      Host 10.10.1.223
        User builder
        Port 22
        IdentityFile ${config.users.users.ezozbek.home}/.ssh/id_ed25519
    '';
  };
}

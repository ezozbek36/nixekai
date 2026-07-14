{pkgs, ...}: {
  programs.zsh = {
    enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      ezozbek = {
        isNormalUser = true;
        initialPassword = "123";
        extraGroups = ["wheel"];
      };
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1hoZGyBJs13/TJSFYBemhMtaY6Qy78xTjV4Wp2QMQ9 ezozbek@swift"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvEU2QT26Kbj0Kyi3JwXU3VRGrLbQbQLC32FXqkwmxF ezozbek@nixos"
        ];
      };
    };
  };
}

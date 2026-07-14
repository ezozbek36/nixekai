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
        extraGroups = ["wheel" "networkmanager"];
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtUq3n5g7jBJtYCZ4jrePM21zo7FniQIpQLDpP9yqAe ezozbek@nixos"];
      };
      builder = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtUq3n5g7jBJtYCZ4jrePM21zo7FniQIpQLDpP9yqAe ezozbek@nixos"];
      };
    };
  };
}

{pkgs, ...}: {
  users = {
    defaultUserShell = pkgs.zsh;
    users.ezozbek = {
      isNormalUser = true;
      useDefaultShell = true;
      description = "Ezozbek";
      extraGroups = ["wheel" "networkmanager" "audio" "video" "render" "relago"];
      hashedPassword = "$6$VS7HOH1y17OVyKwW$.999D5CA/R73BHRayD9UUR84K0Q9/IZbMsVqXdJMjLpBJEz7dpHbzUSQaN.Aem2Wb3evSUuZ7xnM.6J.Ty9m90";
    };
  };
  programs.zsh.enable = true;
}

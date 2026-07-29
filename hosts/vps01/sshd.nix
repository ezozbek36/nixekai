{ ... }: {
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = ["root" "ezozbek"];
    };
  };
}

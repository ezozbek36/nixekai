{ ... }: {
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "ezozbek" ];
    };
  };
}

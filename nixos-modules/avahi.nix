{ ... }: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    reflector = true;
    allowPointToPoint = true;
    publish = {
      hinfo = true;
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}

{...}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      hinfo = true;
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
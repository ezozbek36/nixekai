{ pkgs, ... }: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    ensureDatabases = [
      "hydra"
      "nixbot"
    ];
    ensureUsers = [
      {
        name = "hydra";
        ensureDBOwnership = true;
      }
      {
        name = "nixbot";
        ensureDBOwnership = true;
      }
    ];
  };
}

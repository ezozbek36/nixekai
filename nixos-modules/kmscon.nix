{ pkgs, ... }: {
  services.kmscon = {
    enable = true;
    hwRender = true;
    package = pkgs.kmscon;
    fonts = [
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
  };
}

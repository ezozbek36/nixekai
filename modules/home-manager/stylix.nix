{ pkgs, ... }: {
  stylix = {
    enable = true;
    polarity = "dark";
    autoEnable = false;
    image = ../../assets/wallpapers/ye-graduation-album-cover.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    cursor = {
      size = 24;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    targets = {
      btop.enable = true;
      spicetify.enable = true;
      gnome-text-editor.enable = true;
      zed = {
        enable = true;
        fonts.enable = false;
      };
      gram = {
        enable = true;
        fonts.enable = false;
      };
      alacritty = {
        enable = true;
        fonts.enable = false;
      };
      gtk = {
        enable = true;
        fonts.enable = false;
      };
      gnome = {
        enable = true;
        fonts.enable = false;
      };
    };
  };
}

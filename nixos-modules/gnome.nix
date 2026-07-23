{pkgs, ...}: {
  services.desktopManager.gnome = {
    enable = true;
  };

  services.displayManager.gdm = {
    enable = true;
  };
  
  environment = {
    systemPackages = with pkgs; [resources];
    gnome.excludePackages = with pkgs; [totem epiphany gnome-tour gnome-music gnome-console gnome-system-monitor];
  };
}

{...}: {
  dconf.enable = true;

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
    };
  };

  imports = [
    ./interface.nix
    ./wm.nix
    ./touchpad.nix
    ./shell.nix
    ./dash-to-dock.nix
    ./blur-my-shell.nix
  ];
}

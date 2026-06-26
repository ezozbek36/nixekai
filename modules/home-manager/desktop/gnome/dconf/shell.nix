{config, ...}: {
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions =
        config.home.packages
        |> builtins.filter (pkg: pkg ? extensionUuid)
        |> builtins.map (pkg: pkg.extensionUuid);
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
  };
}

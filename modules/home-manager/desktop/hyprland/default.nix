args @ {
  lib,
  pkgs,
  ...
}: {
  imports = [./rofi.nix];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd = {
      enable = true;
      variables = ["--all"];
    };

    plugins = with pkgs.hyprlandPlugins; [hyprspace];

    settings = {
      mod = {_var = "SUPER";};
      terminal = {_var = "alacritty";};

      config = {
        general = {
          gaps_in = 4;
          gaps_out = 6;
          border_size = 0;
          layout = "dwindle";
          resize_on_border = true;
        };

        decoration = {
          rounding = 8;
          active_opacity = 0.85;
          inactive_opacity = 0.6;
          fullscreen_opacity = 1;
          border_part_of_window = false;

          blur = {
            size = 4;
            noise = 0;
            passes = 3;
            xray = false;
            popups = true;
            enabled = true;
            ignore_opacity = true;
            new_optimizations = true;
            vibrancy_darkness = 0.40;
            popups_ignorealpha = 0.20;
          };
        };

        input = {
          sensitivity = 1;
          touchpad = {
            natural_scroll = true;
          };
        };

        cursor = {
          no_hardware_cursors = 0;
        };

        gestures = {
          workspace_swipe_touch = true;
          workspace_swipe_cancel_ratio = 0.35;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true; # I'm poor :cry:
        };
      };

      bind = import ./binds.nix args;
      monitor = import ./monitors.nix;
      gesture = import ./gestures.nix;
      window_rule = import ./window_rules.nix;

      env = [
        {
          _args = ["AQ_DRM_DEVICES" "/dev/dri/card1:/dev/dri/card0"];
        }
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (
              lib.generators.mkLuaInline
              # lua
              ''
                function()
                    hl.exec_cmd("noctalia-shell")
                end
              ''
            )
          ];
        }
      ];
    };
  };
}

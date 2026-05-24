{pkgs, ...}: {
  home.packages = with pkgs; [
    pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 0;
      };

      input = {
        sensitivity = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      bind = [
        "$mod, T, exec, $terminal"
        "$mod, D, exec, rofi -show drun"
        ", Print, exec, grimblast copy area"
        "ALT, Tab, focuscurrentorlast"
      ];

      monitor = [
        "eDP-1, 2880x1800@120, 0x0, 1.5"
      ];

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true; # I'm poor :cry:
      };

      cursor = {
        no_hardware_cursors = 0;
      };

      env = [
        "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
      ];

      exec-once = [];
    };
  };

  programs.rofi = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 0;
        modules-left = [
          "custom/activities"
          "hyprland/window"
        ];
        modules-center = ["clock"];
        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "battery"
        ];

        "custom/activities" = {
          format = "Activities";
          on-click = "rofi -show drun";
          tooltip = false;
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 56;
          separate-outputs = true;
          rewrite = {
            "" = "Desktop";
          };
        };

        clock = {
          format = "{:%a %b %e  %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
          };
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };

        network = {
          format-wifi = "{icon}";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
        };

        pulseaudio = {
          format = "{icon}";
          format-muted = "󰝟";
          tooltip-format = "{volume}%";
          on-click = "pavucontrol";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "󰂄";
          format-plugged = "󰚥";
          tooltip-format = "{capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: Cantarell, "Adwaita Sans", "JetBrainsMono Nerd Font", sans-serif;
        font-size: 14px;
        font-weight: 600;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 32, 48, 0.88);
        color: #cad3f5;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      tooltip {
        background: rgba(30, 32, 48, 0.96);
        border: 1px solid rgba(202, 211, 245, 0.16);
        border-radius: 8px;
        color: #cad3f5;
      }

      #custom-activities,
      #window,
      #clock,
      #tray,
      #network,
      #pulseaudio,
      #battery {
        margin: 4px 2px;
        padding: 0 10px;
        border-radius: 999px;
        color: #cad3f5;
      }

      #custom-activities {
        margin-left: 6px;
        font-weight: 700;
      }

      #window {
        color: #b8c0e0;
        font-weight: 500;
      }

      window#waybar.empty #window {
        color: #8087a2;
      }

      #clock {
        background: rgba(202, 211, 245, 0.10);
        color: #ffffff;
      }

      #tray,
      #network,
      #pulseaudio,
      #battery {
        padding: 0 8px;
      }

      #battery.warning {
        color: #eed49f;
      }

      #battery.critical {
        color: #ed8796;
      }

      #custom-activities:hover,
      #clock:hover,
      #network:hover,
      #pulseaudio:hover,
      #battery:hover {
        background: rgba(202, 211, 245, 0.14);
      }
    '';
  };
}

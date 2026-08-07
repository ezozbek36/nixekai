{
  lib,
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    installRemoteServer = false;

    extraPackages = with pkgs; [ blueprint-compiler ];

    userSettings = {
      disable_ai = true;
      auto_update = false;
      base_keymap = "VSCode";
      colorize_brackets = true;
      load_direnv = "shell_hook";
      icon_theme = "Material Icon Theme";

      preferred_line_length = 140;
      semantic_tokens = "combined";

      buffer_font_size = 16.0;
      buffer_font_family = "JetBrainsMonoNL Nerd Font Mono";

      format_on_save = "off";
      ensure_final_newline_on_save = false;
      remove_trailing_whitespace_on_save = false;

      git_panel = {
        dock = "left";
        tree_view = true;
      };

      project_panel = {
        dock = "left";
      };

      minimap = {
        show = "always";
        thumb = "hover";
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
        Kotlin = {
          language_servers = [
            "kotlin-language-server"
            "detekt"
            "!kotlin-lsp"
          ];
        };
      };

      lsp = {
        nixd = {
          binary = {
            ignore_system_version = false;
            path = lib.getExe pkgs.nixd;
          };
          settings = {
            diagnostic = {
              suppress = [
                "sema-extra-with"
                "sema-extra-rec"
              ];
            };
          };
        };
        rust-analyzer = {
          binary = {
            ignore_system_version = false;
          };
          initialization_options = {
            check = {
              command = "clippy";
            };
          };
        };
        crates-lsp = {
          binary = {
            ignore_system_version = false;
            path = lib.getExe pkgs.crates-lsp;
          };
        };
        package-version-server = {
          binary = {
            ignore_system_version = false;
            path = lib.getExe pkgs.package-version-server;
          };
        };
        lua-language-server = {
          binary = {
            ignore_system_version = false;
            path = lib.getExe pkgs.lua-language-server;
          };
        };
        ruff = {
          binary = {
            ignore_system_version = false;
            path = lib.getExe pkgs.ruff;
          };
        };
        detekt = {
          binary = {
            ignore_system_version = false;
            path = lib.getExe pkgs.detekt;
          };
        };
        kotlin-language-server = {
          initialization_timeout = 1200000;
          binary = {
            ignore_system_version = false;
            path = lib.getExe pkgs.kotlin-language-server;
            env = {
              JAVA_OPTS = "-Xmx8g";
            };
          };
        };
      };

      git = {
        inline_blame = {
          show_commit_summary = true;
        };
      };

      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      terminal = {
        env = {
          TERM = "alacritty";
        };
      };
    };
  };

  programs.zed-editor-extensions = {
    enable = true;
    packages = with pkgs.zed-extensions; [
      lua
      xml
      nix
      toml
      just
      meson
      kotlin
      blueprint
      crates-lsp
      git-firefly
      material-icon-theme
    ];
  };
}

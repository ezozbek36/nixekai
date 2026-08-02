{ lib, pkgs, ... }:
{
  programs.gram = {
    enable = true;
    package = pkgs.unstable.gram.overrideAttrs rec {
      version = "3.2.0";

      src = pkgs.fetchFromCodeberg {
        owner = "GramEditor";
        repo = "gram";
        tag = version;
        hash = "sha256-AzS9+7HrWbPpjQpmTxwFbOHiLCX7Qzj+vE4zzSJQBRI=";
      };

      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-Setp4mO6PFnLbpjM1UdqZNHfNNk59M2jj9NtwQFXm3A=";
      };
    };
    extensionPackages = with pkgs.zed-extensions; [
      lua
      xml
      nix
      toml
      just
      meson
      kotlin
      crates-lsp
      git-firefly
      material-icon-theme
    ];
    settings = {
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
    };
  };
}

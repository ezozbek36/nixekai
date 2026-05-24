{
  lib,
  pkgs,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    installRemoteServer = false;

    extensions = ["xml" "toml" "just" "meson" "crates-lsp" "git-firefly" "material-icon-theme"];

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
          language_servers = ["nixd" "!nil"];
        };
      };

      lsp = {
        nixd = {
          binary = {
            ignore_system_version = false;
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
    packages = let
      nixGrammar = pkgs.zed-grammars.nix_nix.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "sebb3";
          repo = "tree-sitter-nix";
          rev = "1c903f05d9ff4b74f0836018729ecbefdd0fbdd0";
          hash = "sha256-KQ00kJo350Xhj2pFaaYDcgXvv1CxunnhWIBZth2e5es=";
        };
      });

      nixOverriden = pkgs.zed-extensions.nix.override {zed-grammars = pkgs.zed-grammars // {nix_nix = nixGrammar;};};
      nix = nixOverriden.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "sebb3";
          repo = "nix";
          rev = "926b7150ebba7631cd1ba9227445a3d7e7ec4665";
          sha256 = "sha256-ukS2q0nt8kG5xMc+WiBHZMu66mkBjt9iAnj9gzlA9JQ=";
        };
      });
    in [nix];
  };
}

{ pkgs, ... }: {
  programs.vscode = {
    enable = false;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        editorconfig.editorconfig
        jnoortheen.nix-ide
        mkhl.direnv
        rust-lang.rust-analyzer
        skellock.just
        tamasfe.even-better-toml
        tyriar.sort-lines
        wakatime.vscode-wakatime
      ];
      userSettings = {
        "chat.disableAIFeatures" = true;
        "rust-analyzer.check.command" = "clippy";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.enableImages" = true;
        "terminal.integrated.gpuAcceleration" = "on";
        "update.mode" = "start";
        "window.dialogStyle" = "custom";
      };
    };
  };
}

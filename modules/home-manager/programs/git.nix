{...}: {
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
    settings = {
      init.defaultBranch = "main";
      credential = {
        "https://github.com".helper = ["!gh auth git-credential"];
        "https://gist.github.com".helper = ["!gh auth git-credential"];
      };
      user = {
        name = "Ezozbek";
        email = "git@ezozbek.dev";
      };
    };
  };
}

{...}: {
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      gpg.format = "ssh";
      commit.gpgSign = true;
      init.defaultBranch = "main";
      credential = {
        "https://github.com".helper = ["!gh auth git-credential"];
        "https://gist.github.com".helper = ["!gh auth git-credential"];
      };
      user = {
        name = "Ezozbek";
        email = "git@ezozbek.dev";
        signingkey = "~/.ssh/id_ed25519.pub";
      };
    };
  };
}

{...}: {
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };

  programs.git = {
    enable = true;
    settings = {
      gpg.format = "ssh";
      commit.gpgSign = true;
      init.defaultBranch = "main";
      user = {
        name = "Ezozbek";
        email = "git@ezozbek.dev";
        signingkey = "~/.ssh/id_ed25519.pub";
      };
    };
  };
}

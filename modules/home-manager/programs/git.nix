{
  pkgs,
  config,
  ...
}:
let
  publicSshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtUq3n5g7jBJtYCZ4jrePM21zo7FniQIpQLDpP9yqAe ezozbek@nixos";
in
{
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = publicSshKey;
      signByDefault = true;
    };
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Ezozbek";
        email = "git@ezozbek.dev";
      };
      gpg = {
        ssh = {
          allowedSignersFile =
            ''
              ${config.programs.git.settings.user.email} namespaces="git" ${publicSshKey}
            ''
            |> pkgs.writeText "git_allowed_signers"
            |> toString;
        };
      };
    };
  };
}

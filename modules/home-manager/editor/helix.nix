{...}: {
  programs.helix = {
    enable = true;

    languages = {
      grammar = [
        {
          name = "nix";
          source = {
            git = "https://github.com/nix-community/tree-sitter-nix";
            rev = "69fbfb02896cdd27cb7ff3cd61f7f3f6bde4f017";
          };
        }
      ];
    };
  };
}

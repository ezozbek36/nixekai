/**
Drop this file alongside flake.nix. No config needed.

Auto-discovers nixosConfigurations, darwinConfigurations,
and home-manager options from flake outputs.

Override by declaring `outputs.nixd.options` in flake.nix.

Editor expr usage:
  "(import ./_nixd-expr.nix).nixpkgs"
  "(import ./_nixd-expr.nix).options.nixos"
  "(import ./_nixd-expr.nix).options.home-manager"
  "(import ./_nixd-expr.nix).options.nix-darwin"
*/
let
  # --- Flake resolution (3-tier fallback for nixpkgs) ---
  hasFlake = builtins.pathExists ./flake.nix;
  flake =
    if hasFlake
    then builtins.getFlake (toString ./.)
    else null;

  hasNixd = flake != null && flake ? nixd;
  hasInputs = flake != null && flake ? inputs.nixpkgs;

  nixpkgs =
    if hasNixd && flake.nixd ? nixpkgs
    then import flake.nixd.nixpkgs {}
    else if hasInputs
    then (first flake.nixosConfigurations).pkgs
    else import <nixpkgs> {};

  # --- Helpers ---
  first = set:
    if set == {}
    then null
    else set.${builtins.head (builtins.attrNames set)};

  safeHmOptions = opts:
    if opts ? home-manager.users
    then opts.home-manager.users.type.getSubOptions []
    else null;

  # --- Auto-discovery from flake outputs ---
  nixosOpts = builtins.mapAttrs (_: cfg: cfg.options) (flake.nixosConfigurations or {});

  hmOpts = let
    fromNixos = builtins.mapAttrs (_: safeHmOptions) nixosOpts;
  in
    removeAttrs (builtins.listToAttrs (
      builtins.filter (x: x.value != null) (
        map (name: {
          inherit name;
          value = fromNixos.${name};
        }) (builtins.attrNames fromNixos)
      )
    )) [];

  # --- Resolved options: explicit outputs.nixd wins, else auto-discover ---
  autoOptions = {
    nixos = first nixosOpts;
    home-manager = first hmOpts;
  };

  options =
    if hasNixd && flake.nixd ? options
    then flake.nixd.options
    else autoOptions;
in {
  inherit nixpkgs options flake;
}

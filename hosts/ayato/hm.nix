{ inputs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.ezozbek = import ../../modules/home-manager;
    sharedModules = [
      inputs.stylix.homeModules.stylix
      inputs.zen-browser.homeModules.beta
      inputs.json-schema.homeModules.default
      inputs.zed-extensions.homeManagerModules.default
      inputs.spicetify-nix.homeManagerModules.spicetify
    ];
  };
}

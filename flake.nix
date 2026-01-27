{
  description = "Jacking into the Declarative Matrix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # https://github.com/NixOS/nixpkgs/pull/477062
    nixpkgs-aerospace.url = "github:NixOS/nixpkgs/5a25452a414f1a25d12255261d30df8e80da2a19";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    determinate.url = "github:DeterminateSystems/determinate/v3.15.2";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    homebrew-tw93.url = "github:tw93/homebrew-tap";
    homebrew-tw93.flake = false;
  };

  outputs = inputs @ {self, ...}: {
    darwinConfigurations."alterac" = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs self;};
      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-index-database.darwinModules.nix-index
        inputs.nix-homebrew.darwinModules.nix-homebrew
        (
          {config, ...}: {
            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
          }
        )
        inputs.determinate.darwinModules.default
        ./hosts/alterac
      ];
    };
  };
}

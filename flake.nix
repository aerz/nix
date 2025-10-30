{
  description = "Jacking into the Declarative Matrix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # python 3.14 migration issues, homebrew-core pinned temporary
    # https://github.com/Homebrew/homebrew-core/issues/248654
    homebrew-core.url = "github:homebrew/homebrew-core/0eced82c88d205378ca7963ab9db9e8a76c861ef";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    homebrew-tw93.url = "github:tw93/homebrew-tap";
    homebrew-tw93.flake = false;
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      ...
    }:
    {
      darwinConfigurations."alterac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/alterac
        ];
      };
    };
}

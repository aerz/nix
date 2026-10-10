{
  description = "Jacking into the Declarative Matrix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix4vscode.url = "github:nix-community/nix4vscode";
    nix4vscode.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.brew-src.url = "github:Homebrew/brew/8bf3b3669297a50a8323c0368657365c2e01fa41";
  };

  outputs = inputs @ {self, ...}: {
    darwinConfigurations."alterac" = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs self;};
      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-index-database.darwinModules.nix-index
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.determinate.darwinModules.default
        ./hosts/alterac
      ];
    };
  };
}

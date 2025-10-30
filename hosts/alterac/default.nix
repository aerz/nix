{ self, inputs, pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    ./brew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ({ config, ... }: {
      homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
    })
  ];

  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    settings.experimental-features = "nix-command flakes";
  };

  programs.nix-index-database.comma.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.aerz = {
      imports = [ ../../home ];
    };
  };
  users.users.aerz.home = "/Users/aerz";

  nix-homebrew = {
    enable = true;
    autoMigrate = true;
    enableRosetta = true;
    user = "aerz";

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "tw93/tap" = inputs.homebrew-tw93;
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    bat
    fzf
    tlrc
    just
    gh
    nixfmt-rfc-style
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.variables = {
    EDITOR = "nvim";
    HOMEBREW_NO_ANALYTICS = "1";
  };
}

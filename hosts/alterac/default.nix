{ self, inputs, pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    ./brew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
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

    brave
    telegram-desktop
    localsend
    wezterm
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.variables = {
    EDITOR = "nvim";
    HOMEBREW_NO_ANALYTICS = "1";
  };
}

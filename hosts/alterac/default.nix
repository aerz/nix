{
  self,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    ./brew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    inputs.nix-homebrew.darwinModules.nix-homebrew
    (
      { config, ... }:
      {
        homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
      }
    )
    inputs.determinate.darwinModules.default
  ];

  nix.enable = false; # let determinate nix handle nix configuration
  determinate-nix.customSettings = {
    eval-cores = 2;
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
  # NOTE: manual intervention here to update /etc/shells
  # https://github.com/nix-darwin/nix-darwin/issues/1237
  users.users.aerz.shell = pkgs.fish;
  programs.fish.enable = true;

  nix-homebrew = {
    enable = true;
    autoMigrate = true;
    mutableTaps = true;
    enableRosetta = true;
    user = "aerz";

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "tw93/tap" = inputs.homebrew-tw93;
    };
  };

  # NOTE: fish build test aare failing
  # https://github.com/NixOS/nixpkgs/issues/461406
  nixpkgs.overlays = [
    (final: prev: {
      fish = prev.fish.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # core utils
    eza
    lla
    fd
    ripgrep
    # extra utils
    btop
    dua
    duf
    dust
    dig
    procs
    jq
    tlrc
    hyperfine
    rclone
    yt-dlp
    # misc
    exiftool
    # dev
    broot
    delta
    neovim
    just
    gh
    lazygit
    jujutsu
    zellij
    # nix
    nixfmt-rfc-style
    nix-du
    nurl
    nix-prefetch-git
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.variables = {
    EDITOR = "nvim";
    HOMEBREW_NO_ANALYTICS = "1";
    # TODO: remove when nix-homebrew pin v5
    HOMEBREW_DOWNLOAD_CONCURRENCY = "auto";
  };
}

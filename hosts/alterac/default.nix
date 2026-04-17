{
  self,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    ./brew.nix
    ./settings.nix
    ../../modules/darwin/power-management.nix
    ../../modules/overlays.nix
  ];

  nix.enable = false; # let determinate nix handle nix configuration
  determinateNix.customSettings = {
    eval-cores = 2;
  };

  programs.nix-index-database.comma.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.aerz = {
      imports = [../../home];
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
    mutableTaps = false;
    enableRosetta = false;
    user = "aerz";

    # run the following command to add a tap
    # nix-prefetch-github homebrew homebrew-core --nix
    taps = {
      # homebrew-core and homebrew-cask are not pinned here
      # since homebrew 4.0 formulas resolve via JSON API not local git clone
      # pinning core re-enables legacy code path which overrides third-party
      # taps on upgrade
      # "homebrew/homebrew-core" = ...;
      # "homebrew/homebrew-cask" = ...;
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "0adc601db156eb25901c16410d98383a13fbfd82";
        hash = "sha256-IT/rzv/CVtOoYrEfTQXq5BET8obwfW5bLYoO2yhTadM=";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "7c338f62d34e0bea26d3e8ebee55535ee612c253";
        hash = "sha256-RXqBoRogRSGAZs9saCc1Zk8NkmJiI9PmRTYR29AObnQ=";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # core utils
    ast-grep
    eza
    lla
    fd
    ripgrep
    sd
    tree
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
    ffmpeg
    yt-dlp
    yq
    # misc
    exiftool
    defaultbrowser
    # dev
    broot
    delta
    neovim
    just
    gh
    lazygit
    lnav
    jujutsu
    zellij
    # nix
    alejandra
    nil
    nix-du
    nurl
    update-nix-fetchgit
    nix-prefetch-git
    nix-prefetch-github
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.geist-mono
    geist-font
    inter
  ];

  environment.variables = {
    EDITOR = "nvim";
    HOMEBREW_NO_ANALYTICS = "1";
  };
}

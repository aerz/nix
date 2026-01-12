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
  determinate-nix.customSettings = {
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
    mutableTaps = true;
    enableRosetta = true;
    user = "aerz";

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "tw93/homebrew-tap" = inputs.homebrew-tw93;
    };
  };

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
    ffmpeg
    yt-dlp
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
    nix-prefetch-git
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
  ];

  environment.variables = {
    EDITOR = "nvim";
    HOMEBREW_NO_ANALYTICS = "1";
  };
}

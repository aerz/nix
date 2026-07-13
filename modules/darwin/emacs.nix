{
  config,
  lib,
  pkgs,
  ...
}: {
  nix-homebrew = {
    trust = {
      formulae = [
        "d12frosted/homebrew-emacs-plus/emacs-plus@30"
      ];
    };

    taps = {
      "d12frosted/homebrew-emacs-plus" = pkgs.fetchFromGitHub {
        owner = "d12frosted";
        repo = "homebrew-emacs-plus";
        rev = "8b194a76c2c5b999ba9c023f6cc7227a90696870";
        sha256 = "1dm97dmdviiksv355cs0axgrfpd07v02aq3clr4g73yvbhh5jjy9";
      };
    };
  };

  homebrew.brews = [
    "emacs-plus@30"
    "coreutils" # gls for dired-mode
    "zstd" # undo-fu-session-compression
    "cmake" # vterm

    # avoid zap cleanup failures with emacs-plus
    "libtiff"
    "tree-sitter@0.25"
    "libgccjit"
    "jpeg"
    "zlib"
  ];

  environment.systemPackages = with pkgs; [
    emacs-lsp-booster
    symbola
  ];
}

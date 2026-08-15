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
        rev = "663f3b034602ea39856efce775bc2914f2b3d115";
        sha256 = "0zgh9nyq89ilr2hvqpkgrw233qmsp1ff8bgxn79fkjmdv40dgkrd";
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

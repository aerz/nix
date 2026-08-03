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
        rev = "9dbab0a99642ab563fb3fd4013429800f5a5e9da";
        sha256 = "1v3xn2vr3n4vn0m2andhsmwz9pk3hzlzycajg5n85b094bsklhsp";
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

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
        rev = "bc4151e7c9dc4d9a47b577a4321579680b0bca73";
        sha256 = "17sa0jzg1hc8gvi54zcndxxmccg4ar6lhik9fg0r5r8h54v2xwhj";
      };
    };
  };

  homebrew.brews = [
    "emacs-plus@30"
    "coreutils" # gls for dired-mode
    "zstd" # undo-fu-session-compression
    "cmake" # vterm

    # avoid zap cleanup failures with emacs-plus
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

{
  config,
  lib,
  pkgs,
  ...
}: {
  nix-homebrew = {
    taps = {
      "d12frosted/homebrew-emacs-plus" = pkgs.fetchFromGitHub {
        owner = "d12frosted";
        repo = "homebrew-emacs-plus";
        rev = "76f91f34da08e0d021ac72818c451de63f3f4198";
        sha256 = "04xrd2ccxapxa5hdvycddvp9bypcfzhcbsw4m20wnkdkag6lkj2w";
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

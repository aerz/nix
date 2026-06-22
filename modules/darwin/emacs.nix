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
        rev = "343bf9d50af9027f15dbd2c89396b09f192cf00b";
        sha256 = "19rbsaayagw6a0kzw8fxgx43f6havsv8fb9j2nbgpm11crhjgzdr";
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

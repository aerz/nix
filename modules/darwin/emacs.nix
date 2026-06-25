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
        rev = "dbc974ef02d76f19ce0aadea8ea6416fe41eef2b";
        sha256 = "0qrfxmsvi7k3pkwqk6s0j8gn3ryrl8w8qw69a86h669dakzz7f3x";
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

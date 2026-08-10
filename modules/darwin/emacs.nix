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
        rev = "c6f500c513aa56d0484512fa15fca7168651e864";
        sha256 = "0z878k3pc8id0kpc1ibkdl5krya8mvwk17rkv4wabj2njwpw1j6f";
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

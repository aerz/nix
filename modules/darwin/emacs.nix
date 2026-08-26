{
  config,
  lib,
  pkgs,
  ...
}: let
  emacs = rec {
    name = "emacs-plus@31";
    formula = "d12frosted/emacs-plus/${name}";
    output = "${config.homebrew.prefix}/opt/${name}";
  };
in {
  nix-homebrew = {
    trust = {
      formulae = [emacs.formula];
    };

    taps = {
      "d12frosted/homebrew-emacs-plus" = pkgs.fetchFromGitHub {
        owner = "d12frosted";
        repo = "homebrew-emacs-plus";
        rev = "d0baf34e06d9f17f2c3ba850c8995321802d3b74";
        sha256 = "0rgrk2pl0acj36ryl8hv3mbjggllq16m7ng9b1qy2lhs2ml9yi6c";
      };
    };
  };

  homebrew.brews = [
    {
      name = emacs.formula;
      trusted = true;
      link = "overwrite";
      conflicts_with = ["emacs-plus@30"];
    }
    "coreutils" # gls for dired-mode
    "zstd" # undo-fu-session-compression
    "cmake" # vterm

    # avoid zap cleanup failures with emacs-plus
    "libtiff"
    "tree-sitter"
    "libgccjit"
    "jpeg"
    "zlib"
  ];

  environment.systemPackages = with pkgs; [
    emacs-lsp-booster
    symbola
  ];

  # hook only runs on formula changes
  system.activationScripts.postActivation.text = lib.mkAfter ''
    if [ ! -d "${emacs.output}/Emacs.app" ] || [ ! -d "${emacs.output}/Emacs Client.app" ]; then
      echo "Emacs Plus app bundle is missing: ${emacs.output}" >&2
      exit 1
    fi

    /bin/rm -rf \
      "/Applications/Emacs.app" \
      "/Applications/Emacs Client.app"
    /usr/bin/ditto "${emacs.output}/Emacs.app" "/Applications/Emacs.app"
    /usr/bin/ditto "${emacs.output}/Emacs Client.app" "/Applications/Emacs Client.app"
  '';
}

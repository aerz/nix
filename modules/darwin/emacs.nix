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

  emacsBinary = "${emacs.output}/Emacs.app/Contents/MacOS/Emacs";
in {
  nix-homebrew = {
    trust = {
      formulae = [emacs.formula];
    };

    taps = {
      "d12frosted/homebrew-emacs-plus" = pkgs.fetchFromGitHub {
        owner = "d12frosted";
        repo = "homebrew-emacs-plus";
        rev = "af60b25241b4853325ab55033bd38722e1543a9b";
        sha256 = "0y77qd3pcl3kqqcskqsaw99j18kr80aw75p2n7n14a7wlrfv7y5a";
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

  # Rebuild Emacs if a Homebrew dependency changed its dynamic linkage.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    if [ -x "${emacsBinary}" ] &&
       ! "${emacsBinary}" -Q --batch --version >/dev/null 2>&1; then
      echo "Rebuilding ${emacs.name}: binary failed to load after Homebrew upgrade" >&2
      if ! PATH="${config.homebrew.prefix}/bin:$PATH" \
        /usr/bin/sudo --preserve-env=PATH \
          --user="${config.nix-homebrew.user}" --set-home \
        env brew reinstall --yes --build-from-source "${emacs.formula}"; then
        echo "Re-running the post-install steps for ${emacs.name}" >&2
        if ! PATH="${config.homebrew.prefix}/bin:$PATH" \
          /usr/bin/sudo --preserve-env=PATH \
            --user="${config.nix-homebrew.user}" --set-home \
          env brew postinstall "${emacs.formula}"; then
          echo "error: failed to rebuild ${emacs.name}" >&2
          exit 1
        fi
      fi

      if ! "${emacsBinary}" -Q --batch --version >/dev/null 2>&1; then
        echo "error: ${emacs.name} still cannot load after rebuild" >&2
        exit 1
      fi
    fi

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

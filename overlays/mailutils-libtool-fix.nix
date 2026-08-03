# https://savannah.gnu.org/bugs/?68588
# https://github.com/NixOS/nixpkgs/pull/548382
# https://github.com/NixOS/nixpkgs/issues/548559
# https://github.com/NixOS/nixpkgs/commit/be2442f
# https://raw.githubusercontent.com/NixOS/nixpkgs/be2442f/pkgs/by-name/ma/mailutils/fix-linking-with-libtool-2.6.2.patch
# https://github.com/Xantibody/dotfiles/commit/e5b6d90
final: prev:
prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  mailutils = prev.mailutils.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        (prev.fetchpatch {
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/be2442f/pkgs/by-name/ma/mailutils/fix-linking-with-libtool-2.6.2.patch";
          hash = "sha256-vVOgayGXT15jAAEzLI9moxZOI3rZT40Mxx0991XtbgA=";
        })
      ];
  });
}

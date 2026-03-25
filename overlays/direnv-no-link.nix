# https://github.com/NixOS/nixpkgs/pull/502769
_final: prev: {
  direnv = prev.direnv.overrideAttrs (_: {
    postPatch = ''
      substituteInPlace GNUmakefile --replace-fail " -linkmode=external" ""
    '';
  });
}

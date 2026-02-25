# https://github.com/NixOS/nixpkgs/issues/493775
# https://github.com/NixOS/nixpkgs/pull/493943
# https://github.com/stefankeidel/nix-hosts/commit/4627b9de9b6f195c14583a0bc98b8012400a5739
final: prev: {
  python313 = prev.python313.override {
    packageOverrides = pyFinal: pyPrev: {
      jeepney = pyPrev.jeepney.overrideAttrs (old: {
        doInstallCheck = !prev.stdenv.isDarwin;
        pythonImportsCheck =
          builtins.filter
          (m: m != "jeepney.io.trio")
          (old.pythonImportsCheck or []);
      });
    };
  };
}

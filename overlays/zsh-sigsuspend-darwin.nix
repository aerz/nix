# zsh build hang on Darwin (checkPhase sigsuspend)
# https://github.com/NixOS/nixpkgs/issues/513543
final: prev: {
  zsh = prev.zsh.overrideAttrs (old: prev.lib.optionalAttrs prev.stdenv.isDarwin {
    preConfigure = (old.preConfigure or "") + ''
      export zsh_cv_sys_sigsuspend=yes
    '';
  });
}

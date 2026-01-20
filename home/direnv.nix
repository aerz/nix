{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      export GNUPGHOME="${config.programs.gpg.homedir}"
    '';
  };
}

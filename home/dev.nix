{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
  };
}

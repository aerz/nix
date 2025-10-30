{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./alias.nix
    ./keybindings.nix
  ];

  home.file.".hushlogin".text = "";
}

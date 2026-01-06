{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/darwin/raycast.nix
  ];

  raycast.enable = false;
}

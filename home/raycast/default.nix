{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/home-manager/darwin/raycast.nix
  ];

  raycast.enable = false;
}

{config, ...}: {
  imports = [
    ../../modules/home-manager/darwin/raycast.nix
  ];

  raycast = {
    enable = true;
    source = ./scripts;
    target = "${config.home.homeDirectory}/Documents/Raycast/Scripts";
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    raycast = {
      enable = lib.mkEnableOption {
        description = "Enable Raycast";
        default = false;
      };
    };
  };

  config = lib.mkIf config.raycast.enable {
    home.file."Documents/Raycast/Scripts" = {
      source = ./scripts;
      executable = true;
      recursive = true;
    };
  };
}

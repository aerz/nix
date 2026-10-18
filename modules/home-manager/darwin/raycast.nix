{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.raycast;
in {
  options.raycast = {
    enable = lib.mkEnableOption "copying Raycast scripts";

    source = lib.mkOption {
      type = lib.types.path;
      description = "Directory containing Raycast scripts to copy on activation.";
    };

    target = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Documents/Raycast/Scripts";
      description = "Destination directory for the copied Raycast scripts.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.syncRaycastScripts = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p ${lib.escapeShellArg cfg.target}
      run ${pkgs.rsync}/bin/rsync \
        --recursive --copy-links --checksum --perms --chmod=755 \
        ${lib.escapeShellArg "${cfg.source}/"} \
        ${lib.escapeShellArg "${cfg.target}/"}
    '';
  };
}

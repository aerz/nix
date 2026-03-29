#
# Mac App Store Module
#
# This module manages Mac App Store applications directly through Home Manager
# activation instead of relying on brew bundle integration.
#
# Motivation:
# - https://github.com/nix-darwin/nix-darwin/issues/1722
# - https://github.com/Homebrew/brew/issues/21559
# - https://github.com/nix-darwin/nix-darwin/blob/da529ac9e46f25ed5616fd634079a5f3c579135f/modules/homebrew.nix#L879
# - https://github.com/Homebrew/brew/blob/ff29aa966b3127a32e5637bde7d5c0195186d6d4/Library/Homebrew/bundle/extensions/mac_app_store.rb#L203-L204
# - Workaround issues with the brew bundle
# - Use mas-cli directly to shorten the tool chain
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkOption
    types
    literalExpression
    concatStringsSep
    mapAttrsToList
    escapeShellArg
    ;

  cfg = config.aerz.masApps;
in {
  options.aerz.masApps = mkOption {
    type = types.attrsOf types.ints.positive;
    default = {};
    example = literalExpression ''
      {
        "1Password for Safari" = 1569813296;
        Xcode = 497799835;
      }
    '';
    description = ''
      Mac App Store applications to install and upgrade using mas.
      By default, this will disable the auto-indexing feature to give you explicit control
      over the apps you want to manage.

      For more information on {command}`mas` see:
      [github.com/mas-cli/mas](https://github.com/mas-cli/mas).
    '';
  };

  config = mkIf (cfg != {}) {
    home.activation.installMasApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
      set -euo pipefail

      export MAS_NO_AUTO_INDEX=1
      mas_apps_installed="$("${lib.getExe pkgs.mas}" list | "${lib.getExe pkgs.gawk}" '{print $1}')"

      ${concatStringsSep "\n" (mapAttrsToList (name: id: ''
          if ! printf '%s\n' "$mas_apps_installed" | "${lib.getExe pkgs.gnugrep}" -qx '${toString id}'; then
            echo ${escapeShellArg "Installing ${name} ${toString id}..."}
            "${lib.getExe pkgs.mas}" get ${toString id} || {
              echo ${escapeShellArg "mas install failed for ${name} (${toString id})"} >&2
              exit 1
            }
          fi
        '')
        cfg)}

      ${concatStringsSep "\n" (mapAttrsToList (name: id: ''
          if printf '%s\n' "$mas_apps_installed" | "${lib.getExe pkgs.gnugrep}" -qx '${toString id}'; then
            echo ${escapeShellArg "Upgrading ${name} ${toString id}..."}
            "${lib.getExe pkgs.mas}" upgrade ${toString id} || {
              echo ${escapeShellArg "mas upgrade failed for ${name} (${toString id})"} >&2
              exit 1
            }
          else
            echo ${escapeShellArg "App ${name} ${toString id} is not installed ... skipped"}
          fi
        '')
        cfg)}
    '';
  };
}

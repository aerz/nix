# VS Code Mutable Configuration Module
#
# This module provides a fully mutable alternative to Home Manager's official
# programs.vscode module, designed for users who need VS Code to function with
# full write access to settings and extensions.
#
# Key differences from official module:
# - Extensions are synced to allow write access
# - Settings files are copied from nix-store
# - Recommended for darwin systems and discouraged for others
#
# Motivation:
# - Allow user settings changes without switch
# - Extensions with write permissions to their own files
# - Extension state management
#
# References:
# - https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode/default.nix
# - https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/vscode/extensions/vscode-utils.nix
# - https://github.com/NixOS/nixpkgs/blob/fb7944c166a3b630f177938e478f0378e64ce108/pkgs/applications/editors/vscode/extensions/vscode-utils.nix#L161
# - https://nixos.wiki/wiki/Visual_Studio_Code
# - https://github.com/nix-community/home-manager/issues/7188
#   vscode-fhs solves certain problems but pkg is not available for darwin
# - https://github.com/nix-community/home-manager/issues/7880
#   mutableExtensionsDir is available but is not flexible
#
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    literalExpression
    mapAttrs'
    nameValuePair
    attrNames
    filter
    escapeShellArg
    concatStringsSep
    flatten
    mapAttrsToList
    ;

  cfg = config.aerz.vscode;

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  userDataDir =
    if isDarwin then
      "${config.home.homeDirectory}/Library/Application Support/Code/User"
    else
      "${config.xdg.configHome}/Code/User";

  globalStorageDir = "${userDataDir}/globalStorage";
  storageJsonPath = "${globalStorageDir}/storage.json";
  profilesBaseDir = "${userDataDir}/profiles";

  extensionsBaseDir = "${config.home.homeDirectory}/.vscode/extensions";

  jsonFormat = pkgs.formats.json { };

  profileType = types.submodule (
    { name, ... }:
    {
      options = {
        settings = mkOption {
          type = jsonFormat.type;
          default = { };
          example = literalExpression ''
            {
              "editor.formatOnSave" = true;
              "workbench.colorTheme" = "Dracula";
            }
          '';
          description = ''
            Configuration written to this profile's settings.json.
          '';
        };

        extensions = mkOption {
          type = types.listOf types.package;
          default = [ ];
          example = literalExpression ''
            with pkgs.vscode-extensions; [
              jnoortheen.nix-ide
              dracula-theme.theme-dracula
            ]
          '';
          description = ''
            List of VSCode extension packages for this profile.
          '';
        };
      };
    }
  );

  toExtensionsJson =
    extensions:
    let
      toExtensionJsonEntry = ext: rec {
        identifier = {
          id = ext.vscodeExtUniqueId;
          uuid = "";
        };

        version = ext.version;

        relativeLocation = ext.vscodeExtUniqueId;

        location = {
          "$mid" = 1;
          fsPath = "${extensionsBaseDir}/${ext.vscodeExtUniqueId}";
          path = location.fsPath;
          scheme = "file";
        };

        metadata = {
          id = "";
          publisherId = "";
          publisherDisplayName = ext.vscodeExtPublisher;
          targetPlatform = "undefined";
          isApplicationScoped = false;
          updated = false;
          isPreReleaseVersion = false;
          installedTimestamp = 0;
          preRelease = false;
        };
      };
    in
    builtins.toJSON (map toExtensionJsonEntry extensions);

  allExtensions = lib.unique (
    lib.concatMap (profile: profile.extensions) (lib.attrValues cfg.profiles)
  );

  combinedAllExtensions = pkgs.buildEnv {
    name = "vscode-all-extensions";
    paths = allExtensions;
  };

  profileData = mapAttrs' (
    profileName: profileCfg:
    let
      isDefault = profileName == "default";

      settingsDir = if isDefault then userDataDir else "${profilesBaseDir}/${profileName}";
      extensionsJsonPath =
        if isDefault then
          "${extensionsBaseDir}/extensions.json"
        else
          "${profilesBaseDir}/${profileName}/extensions.json";

      settingsFile = jsonFormat.generate "vscode-settings-${profileName}.json" profileCfg.settings;

      extensionsJsonFile = pkgs.writeTextFile {
        name = "vscode-extensions-${profileName}.json";
        text = toExtensionsJson profileCfg.extensions;
      };
    in
    nameValuePair profileName {
      inherit
        profileName
        settingsDir
        extensionsJsonPath
        settingsFile
        extensionsJsonFile
        isDefault
        ;
      hasSettings = profileCfg.settings != { };
      hasExtensions = profileCfg.extensions != [ ];
    }
  ) cfg.profiles;

  customProfileNames = filter (name: name != "default") (attrNames cfg.profiles);
in
{
  options.aerz.vscode = {
    enable = mkEnableOption "Visual Studio Code";

    profiles = mkOption {
      type = types.attrsOf profileType;
      default = { };
      example = literalExpression ''
        {
          default = {
            settings = {
              "editor.formatOnSave" = true;
              "workbench.colorTheme" = "Dracula";
            };
            extensions = with pkgs.vscode-extensions; [
              dracula-theme.theme-dracula
            ];
          };

          rust = {
            settings = {
              "editor.formatOnSave" = true;
              "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
            };
            extensions = with pkgs.vscode-extensions; [
              rust-lang.rust-analyzer
            ];
          };
        }
      '';
      description = ''
        VSCode profiles configuration.
      '';
    };
  };

  config = mkIf cfg.enable {

    home.activation.installExtensions = mkIf (allExtensions != [ ]) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        EXTENSIONS_SOURCE="${combinedAllExtensions}/share/vscode/extensions/"

        run mkdir -p "${extensionsBaseDir}"

        if [[ ! -d "$EXTENSIONS_SOURCE" ]]; then
          echo "WARN: No extensions source found at $EXTENSIONS_SOURCE" >&2
        else
          verboseEcho "Syncing ALL VSCode extensions to shared directory..."
          run ${pkgs.rsync}/bin/rsync -aL --delete --chmod=u+w --no-times \
            "$EXTENSIONS_SOURCE" "${extensionsBaseDir}/"
        fi
      ''
    );

    home.activation.setupProfiles = mkIf (customProfileNames != [ ]) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        file="${storageJsonPath}"
        profiles=(${concatStringsSep " " (map lib.escapeShellArg customProfileNames)})

        verboseEcho "Managing VSCode profiles in storage.json"

        run mkdir -p "$(dirname "$file")"

        [[ -f "$file" ]] || echo '{}' > "$file"

        for profile in "''${profiles[@]}"; do
          verboseEcho "Ensuring profile exists: $profile"

          if ${pkgs.jq}/bin/jq --arg name "$profile" \
            '.userDataProfiles //= [] |
             if (.userDataProfiles | map(.name) | index($name)) then .
             else .userDataProfiles += [{name: $name, location: $name}]
             end' \
            "$file" > "$file.tmp"; then
            run mv "$file.tmp" "$file"
          else
            rm -f "$file.tmp"
            echo "ERROR: Failed to update profile '$profile'" >&2
            exit 1
          fi
        done

        run chmod 644 "$file"
      ''
    );

    home.activation.writeProfileSettings =
      let
        writeSettingsScripts = concatStringsSep "\n" (
          mapAttrsToList (
            profileName: profileData:
            lib.optionalString profileData.hasSettings ''
              verboseEcho "Writing settings.json for profile '${profileName}'"
              run mkdir -p "${profileData.settingsDir}"
              run install -m 0644 "${profileData.settingsFile}" "${profileData.settingsDir}/settings.json"
            ''
          ) profileData
        );
      in
      mkIf (profileData != { }) (lib.hm.dag.entryAfter [ "writeBoundary" ] writeSettingsScripts);

    home.activation.writeExtensionsJson =
      let
        writeExtensionsJsonScripts = concatStringsSep "\n" (
          mapAttrsToList (
            profileName: profileData:
            lib.optionalString profileData.hasExtensions ''
              verboseEcho "Writing extensions.json for profile '${profileName}'"
              run mkdir -p "$(dirname "${profileData.extensionsJsonPath}")"
              run install -m 0644 "${profileData.extensionsJsonFile}" "${profileData.extensionsJsonPath}"
            ''
          ) profileData
        );
      in
      mkIf (profileData != { }) (
        lib.hm.dag.entryAfter [ "installExtensions" ] writeExtensionsJsonScripts
      );
  };
}

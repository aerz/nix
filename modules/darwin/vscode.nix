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

  toLocalExtensionJson =
    extensions:
    let
      extensionInfo = map (
        ext:
        let
          extMeta = ext.passthru or { };
          publisher = extMeta.publisher or (lib.head (lib.splitString "." ext.vscodeExtUniqueId));
          name = extMeta.name or (lib.last (lib.splitString "." ext.vscodeExtUniqueId));
          version = extMeta.version or ext.version;
          extensionId = "${publisher}.${name}";
          localPath = "${extensionsBaseDir}/${extensionId}";
        in
        {
          identifier = {
            id = ext.vscodeExtUniqueId;
            uuid = "";
          };
          version = version;
          location = {
            "$mid" = 1;
            fsPath = localPath;
            external = "file://${localPath}";
            path = localPath;
            scheme = "file";
          };
          relativeLocation = extensionId;
          metadata = {
            id = "";
            publisherId = "";
            publisherDisplayName = publisher;
            targetPlatform = "undefined";
            isPreReleaseVersion = false;
            preRelease = false;
            installedTimestamp = 0;
            isApplicationScoped = false;
            updated = false;
          };
        }
      ) extensions;
    in
    builtins.toJSON extensionInfo;

  allExtensions = lib.unique (
    flatten (mapAttrsToList (name: profile: profile.extensions) cfg.profiles)
  );

  combinedAllExtensions = pkgs.buildEnv {
    name = "vscode-all-extensions";
    paths = allExtensions;
  };

  profileConfigs = mapAttrs' (
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
        text = toLocalExtensionJson profileCfg.extensions;
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

  nonDefaultProfileNames = filter (name: name != "default") (attrNames cfg.profiles);
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
    home.packages = [
      pkgs.rsync
      pkgs.jq
    ];

    home.activation.installVSCodeExtensionsShared = mkIf (allExtensions != [ ]) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        EXTENSIONS_SOURCE="${combinedAllExtensions}/share/vscode/extensions/"

        $DRY_RUN_CMD mkdir -p "${extensionsBaseDir}"

        if [[ ! -d "$EXTENSIONS_SOURCE" ]]; then
          echo "WARN: No extensions source found at $EXTENSIONS_SOURCE" >&2
        else
          $VERBOSE_ECHO "Syncing ALL VSCode extensions to shared directory..."
          $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync -aL --delete --chmod=u+w --no-times \
            "$EXTENSIONS_SOURCE" "${extensionsBaseDir}/"
        fi
      ''
    );

    home.activation.vscodeProfiles = mkIf (nonDefaultProfileNames != [ ]) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        file="${storageJsonPath}"
        profiles=(${concatStringsSep " " (map lib.escapeShellArg nonDefaultProfileNames)})

        $VERBOSE_ECHO "Managing VSCode profiles in storage.json"

        mkdir -p "$(dirname "$file")"

        if [[ ! -f "$file" ]]; then
          echo '{}' > "$file"
        fi

        for profile in "''${profiles[@]}"; do
          $VERBOSE_ECHO "Checking profile: $profile"

          profile_exists=$(${pkgs.jq}/bin/jq --arg name "$profile" \
            '.userDataProfiles // [] | any(.name == $name)' "$file")

          if [[ "$profile_exists" != "true" ]]; then
            $VERBOSE_ECHO "Adding profile: $profile"

            ${pkgs.jq}/bin/jq --arg name "$profile" \
              '.userDataProfiles = (.userDataProfiles // []) + [{name: $name, location: $name}]' \
              "$file" > "$file.tmp" && mv "$file.tmp" "$file"
          else
            $VERBOSE_ECHO "Profile $profile already exists, skipping"
          fi
        done

        chmod 644 "$file"
      ''
    );

    home.activation.writeVSCodeProfileSettings =
      let
        writeSettingsScripts = concatStringsSep "\n" (
          mapAttrsToList (
            profileName: profileData:
            lib.optionalString profileData.hasSettings ''
              $VERBOSE_ECHO "Writing settings for VSCode profile '${profileName}'"
              $DRY_RUN_CMD mkdir -p "${profileData.settingsDir}"
              $DRY_RUN_CMD install -m 0644 "${profileData.settingsFile}" "${profileData.settingsDir}/settings.json"
            ''
          ) profileConfigs
        );
      in
      mkIf (profileConfigs != { }) {
        after = [ "writeBoundary" ];
        before = [ ];
        data = writeSettingsScripts;
      };

    home.activation.writeVSCodeProfileExtensionsJson =
      let
        writeExtensionsJsonScripts = concatStringsSep "\n" (
          mapAttrsToList (
            profileName: profileData:
            lib.optionalString profileData.hasExtensions ''
              $VERBOSE_ECHO "Writing extensions.json for VSCode profile '${profileName}'"
              $DRY_RUN_CMD mkdir -p "$(dirname "${profileData.extensionsJsonPath}")"
              $DRY_RUN_CMD install -m 0644 "${profileData.extensionsJsonFile}" "${profileData.extensionsJsonPath}"
            ''
          ) profileConfigs
        );
      in
      mkIf (profileConfigs != { }) (
        lib.hm.dag.entryAfter [ "installVSCodeExtensionsShared" ] writeExtensionsJsonScripts
      );
  };
}

#
# references
#
# https://github.com/NixOS/nixpkgs/blob/80e2deac6ae165f12c5c963eb793372c2e0193d2/pkgs/applications/editors/vscode/extensions/mktplcExtRefToFetchArgs.nix
# https://github.com/NixOS/nixpkgs/blob/80e2deac6ae165f12c5c963eb793372c2e0193d2/pkgs/applications/editors/vscode/extensions/vscode-utils.nix
# https://github.com/nix-community/nix4vscode/tree/master/crates/code_api
# https://github.com/microsoft/vscode/blob/d187d50a482ff80dcf74c35affb09dda1a7cd2fe/src/vs/platform/extensions/common/extensions.ts
# https://learn.microsoft.com/en-us/javascript/api/azure-devops-extension-api/extensionqueryflags
#
function nix-vscode-extension-hash -d "Generate the mktplcRef attrset to override a VSCode Marketplace extension in nixpkgs"

    function _curl_vscode_marketplace
        argparse 'i/id=' 'f/flag=' -- $argv
        or return 1

        set -l body (jq -cn --arg id "$_flag_id" --arg flag "$_flag_flag" \
                   '{filters:[{criteria:[{filterType:7,value:$id}],pageNumber:1,pageSize:1}],flags:$flag}')

        curl -fsSL \
            -X POST \
            -H "Content-Type: application/json" \
            -H "Accept: application/json;api-version=6.0-preview.1" \
            --data "$body" \
            "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"
    end

    function _platform -a requested
        set -l supported linux-arm64 linux-x64 darwin-arm64

        if test -n "$requested"
            if not contains -- $requested $supported
                echo "error: unsupported platform '$requested'" >&2
                return 1
            end
            echo $requested
        else
            set -l os (string lower (uname -s))
            set -l arch (uname -m)
            switch "$os-$arch"
                case linux-aarch64 linux-arm64
                    echo linux-arm64
                case linux-x86_64
                    echo linux-x64
                case darwin-arm64
                    echo darwin-arm64
                case '*'
                    echo "error: unsupported platform '$os-$arch'" >&2
                    return 1
            end
        end
    end

    # query vscode marketplace for an extension and prints a tab-separated line details: version\ttargeted\tarch
    # args: --id --target-platform [--version <ver>] [--pre-release]
    function _query_extension
        argparse 'i/id=' 't/target-platform=' 'v/version=' p/pre-release -- $argv
        or return 1

        if set -q _flag_version
            set -l extensions_json (_curl_vscode_marketplace --id "$_flag_id" --flag 1)
            or begin
                echo "error: '$_flag_id' not found in the marketplace" >&2
                return 1
            end

            set -l versions_json (echo $extensions_json | jq -cer '.results[0].extensions[0].versions')
            or begin
                echo "error: '$_flag_id' not found in the marketplace" >&2
                return 1
            end

            set -l exists (echo $versions_json | jq -r --arg v "$_flag_version" 'any(.[]; .version == $v)')
            if test "$exists" != true
                echo "error: version '$_flag_version' not found for '$_flag_id'" >&2
                return 1
            end

            set -l target ""
            set -l targeted (printf '%s\n' $versions_json | jq -r \
                --arg v "$_flag_version" \
                'any(.[]; .version == $v and (.targetPlatform // "") != "")')
            if test "$targeted" = true
                set target (_platform $_flag_target_platform)
                or return 1
            end

            printf '%s\n' $versions_json | jq -er \
                --arg v "$_flag_version" \
                --arg target $target '
                . as $all
                | [$all[] | select(.version == $v)] as $entries
                | if ($entries | length) == 0 then error("version not found")
                  elif ($target != "" and ($entries | any(.[]; (.targetPlatform // "") == $target)))
                    then [$entries[0].version, "true", $target]
                  elif ($entries | any(.[]; (.targetPlatform // "") == ""))
                    then [$entries[0].version, "false", ""]
                  else error("no matching entry")
                  end
                | @tsv
            '
            or begin
                echo "error: no matching version found for '$_flag_id'" >&2
                return 1
            end

        else
            set -l extensions_json (_curl_vscode_marketplace --id "$_flag_id" --flag 65536)
            or begin
                echo "error: '$_flag_id' not found in the marketplace" >&2
                return 1
            end

            set -l versions_json (echo $extensions_json | jq -cer '.results[0].extensions[0].versions')
            or begin
                echo "error: '$_flag_id' not found in the marketplace" >&2
                return 1
            end

            set -l target ""
            set -l targeted (printf '%s\n' $versions_json | jq -r \
                'any(.[]; (.targetPlatform // "") != "")')
            if test "$targeted" = true
                set target (_platform $_flag_target_platform)
                or return 1
            end

            set -l prerelease (set -q _flag_pre_release; and echo true; or echo false)

            printf '%s\n' $versions_json | jq -er \
                --arg target $target \
                --argjson prerelease $prerelease '
                def is_prerelease:
                    (.flags // "") | if type == "array"
                        then any(.[]; ascii_downcase == "prerelease")
                        else ascii_downcase | contains("prerelease") end;
                def unique_versions:
                    reduce .[] as $v ([]; if any(.[]; . == $v.version) then . else . + [$v.version] end);
                . as $all
                | [ unique_versions[] as $v
                    | [$all[] | select(.version == $v)] as $entries
                    | select(($entries[0] | is_prerelease) == $prerelease)
                    | if ($target != "" and ($entries | any(.[]; (.targetPlatform // "") == $target)))
                        then [$entries[0].version, "true", $target]
                      elif ($entries | any(.[]; (.targetPlatform // "") == ""))
                        then [$entries[0].version, "false", ""]
                      else empty
                      end
                  ][0]
                | select(. != null) | @tsv
            '
            or begin
                echo "error: no matching version found for '$_flag_id'" >&2
                return 1
            end
        end
    end

    argparse --max-args 1 h/help 'v/version=' 't/target-platform=' p/pre-release -- $argv
    or return 1

    if set -q _flag_help; or test (count $argv) -eq 0
        echo "\
Generate the mktplcRef attrset needed to override vscode-utils.buildVscodeMarketplaceExtension
for a specific extension in nixpkgs.

Usage:
  nix-vscode-extension-hash <publisher.name>
  nix-vscode-extension-hash <publisher.name> [-v <version>] [-t <platform>]
  nix-vscode-extension-hash <publisher.name> [-p] [-t <platform>]
  nix-vscode-extension-hash (-h | --help)

Options:
  -v --version=<version>       Specific extension version to fetch. Defaults to latest.
  -t --target-platform=<platform>
                               Target platform for architecture-specific extensions.
                               Supported: linux-x64, linux-arm64, darwin-arm64.
                               Auto-detected from the current system if omitted.
  -p --pre-release             Fetch the latest pre-release version instead of stable.
  -h --help                    Show this screen.

Examples:
  nix-vscode-extension-hash ms-python.python
  nix-vscode-extension-hash ms-python.python -v 2024.1.0
  nix-vscode-extension-hash ms-python.python -t linux-arm64
  nix-vscode-extension-hash ms-python.python -p"
        return 0
    end

    set -l id_parts (string split -m1 -n '.' $argv[1])
    if test (count $id_parts) -ne 2
        echo "error: expected 'publisher.name', got: '$argv[1]'" >&2
        return 1
    end

    set -l publisher $id_parts[1]
    set -l name $id_parts[2]
    set -l ext_id "$publisher.$name"

    set -l query_args --id "$ext_id" --target-platform "$_flag_target_platform"
    set -q _flag_version; and set query_args $query_args --version "$_flag_version"
    set -q _flag_pre_release; and set query_args $query_args --pre-release

    set -l ext_tsv (_query_extension $query_args)
    or return 1

    set -l ext (string split \t -- $ext_tsv)
    set -l ver $ext[1]
    set -l targeted $ext[2]
    set -l arch $ext[3]

    set -l url "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/$ver/vspackage"
    test "$targeted" = true; and set url "$url?targetPlatform=$arch"

    set -l hash (nix-prefetch-url --type sha256 "$url" | tail -1)
    or begin
        echo "error: failed to fetch package for '$ext_id@$ver'" >&2
        return 1
    end

    set -l hash64 (nix-hash --type sha256 --to-base64 "$hash")

    set -l out "
mktplcRef = {
  name      = \"$name\";
  publisher = \"$publisher\";
  version   = \"$ver\";"
    test "$targeted" = true; and set out "$out
  arch      = \"$arch\";"
    echo "$out
  hash      = \"sha256-$hash64\";
};"
end

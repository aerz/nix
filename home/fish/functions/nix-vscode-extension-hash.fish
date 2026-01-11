function nix-vscode-extension-hash -d "Generate sha256 hash for nixpkgs vscode-utils.buildVscodeMarketplaceExtension"
    argparse --max-args 1 --min-args 1 h/help 'v/version=' -- $argv
    or return
    if set -q _flag_help; or test (count $argv) -eq 0
        echo "\
Generate valid hash for build vscode extension with nix.

Usage:
    nix-vscode-extension-hash <publisher.name>
    nix-vscode-extension-hash <publisher.name> [-v <version>]
    nix-vscode-extension-hash -h | --help"
        return 0
    end

    set -l ext_id $argv[1]
    if test -z $ext_id
        echo "error: missing extension id argument" >&2
        return 1
    end

    set -l ext_id_parts (string split -m1 -n '.' $ext_id)
    if test (count $ext_id_parts) -ne 2
        echo "error: expected identifier with format 'publisher.name', got: '$ext_id'" >&2
        return 1
    end

    set -l ext_publisher $ext_id_parts[1]
    set -l ext_name $ext_id_parts[2]

    set -l ext_version latest
    if set -q _flag_version
        set ext_version $_flag_version
    end

    if [ "$ext_version" = latest ]
        set -l body (jq -n --arg id "$ext_publisher.$ext_name" \
            '{filters:[{criteria:[{filterType:7,value:$id}],pageNumber:1,pageSize:1}],flags:512}')

        set ext_version (
            curl -fsSL \
                -H "Content-Type: application/json" \
                -H "Accept: application/json;api-version=6.0-preview.1" \
                --data "$body" \
                "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" | \
            jq -er '.results.[0].extensions[0].versions[0].version')
    end

    set -l hash (nix-prefetch-url --type sha256 \
        "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$ext_publisher/vsextensions/$ext_name/$ext_version/vspackage")
    set hash (echo $hash | tail -1)
    set -l hash64 (nix-hash --type sha256 --to-base64 "$hash")

    echo "\
mktplcRef = {
    name = \"$ext_name\";
    publisher = \"$ext_publisher\";
    version = \"$ext_version\";
    hash = \"sha256-$hash64\";
}"
end

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

    set -l id $argv[1]
    if test -z $id
        echo "error: missing extension id argument" >&2
        return 1
    end

    set -l id_parts (string split -m1 -n '.' $id)
    if test (count $id_parts) -ne 2
        echo "error: expected identifier with format 'publisher.name', got: '$id'" >&2
        return 1
    end

    set -l publisher $id_parts[1]
    set -l name $id_parts[2]

    set -l ver latest
    if set -q _flag_version
        set ver $_flag_version
    end

    function _curl_vscode_marketplace
        # args: --id "publisher.name" --flag 512
        argparse 'i/id=' 'f/flag=' -- $argv
        or return 1

        # https://learn.microsoft.com/en-us/javascript/api/azure-devops-extension-api/extensionqueryflags
        set -l body (jq -cn --arg id "$_flag_id" --arg flag "$_flag_flag" \
                     '{filters:[{criteria:[{filterType:7,value:$id}],pageNumber:1,pageSize:1}],flags:$flag}')

        curl -fsSL \
            -X POST \
            -H "Content-Type: application/json" \
            -H "Accept: application/json;api-version=6.0-preview.1" \
            --data "$body" \
            "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"
    end

    set -l published (_curl_vscode_marketplace --id "$publisher.$name" --flag 0 | \
                      jq '.results[0].extensions | length > 0')
    if [ "$published" = false ]
        echo "error: '$publisher.$name' is not published in vscode marketplace" >&2
        return 1
    end

    if [ "$ver" = latest ]
        set ver (_curl_vscode_marketplace --id "$publisher.$name" --flag 512 | \
                         jq -er '.results.[0].extensions[0].versions[0].version')
    end

    set -l hash (nix-prefetch-url --type sha256 \
                 "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/$ver/vspackage")
    set hash (echo $hash | tail -1)
    set -l hash64 (nix-hash --type sha256 --to-base64 "$hash")

    echo "\
mktplcRef = {
    name = \"$name\";
    publisher = \"$publisher\";
    version = \"$ver\";
    hash = \"sha256-$hash64\";
};"
end

function nix-vscode-extension-hash -d "Generate sha256 hash for nixpkgs vscode-utils.buildVscodeMarketplaceExtension"
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

    argparse --max-args 1 h/help 'v/version=' 'a/arch=' -- $argv
    or return
    if set -q _flag_help; or test (count $argv) -eq 0
        echo "\
Generate valid hash for build vscode extension with nix.

Usage:
    nix-vscode-extension-hash <publisher.name>
    nix-vscode-extension-hash <publisher.name> [-v <version>] [-a <platform-arch>]
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

    set -l supported_archs linux-arm64 linux-x64 darwin-arm64
    if not set -q _flag_arch; or test -z "$_flag_arch"
        set -l os (string lower (uname -s))
        set -l machine (uname -m)

        switch "$os-$machine"
            case linux-aarch64 linux-arm64
                set _flag_arch linux-arm64
            case linux-x86_64
                set _flag_arch linux-x64
            case darwin-arm64
                set _flag_arch darwin-arm64
            case '*'
                echo "error: current platform '$os-$machine' is not supported" >&2
                return 1
        end
    end
    if not contains -- "$_flag_arch" $supported_archs
        echo "error: selected platform '$_flag_arch' is not supported" >&2
        return 1
    end
    set -l arch $_flag_arch

    set -l ver latest
    if set -q _flag_version
        set ver $_flag_version
    end

    set -l published (_curl_vscode_marketplace --id "$publisher.$name" --flag 0 | \
                      jq '.results[0].extensions | length > 0')
    if [ "$published" = false ]
        echo "error: '$publisher.$name' is not published in vscode marketplace" >&2
        return 1
    end

    if [ "$ver" = latest ]
      if not set ver (_curl_vscode_marketplace --id "$publisher.$name" --flag 65536 | \
          jq -er --arg arch "$arch" '
            .results[0].extensions[0].versions
            | map(select(
                (.targetPlatform // "") == $arch
                and ((.flags // "") | contains("prerelease") | not)
              ))
            | .[0].version
          ')
          echo "error: there is no version published for your platform '$arch'" >&2
          return 1
      end
    end

    if not set -l hash (nix-prefetch-url --type sha256 \
        "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/$ver/vspackage?targetPlatform=$arch")
        echo "error: version '$ver' is not published for platform '$arch'" >&2
        return 1
    end
    set hash (echo $hash | tail -1)
    set -l hash64 (nix-hash --type sha256 --to-base64 "$hash")

    echo "\
mktplcRef = {
    name = \"$name\";
    publisher = \"$publisher\";
    version = \"$ver\";
    arch = \"$arch\";
    hash = \"sha256-$hash64\";
};"
end

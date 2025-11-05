function nix-vscode-extension-hash -d "Generate hash value for nixpkgs.vscode-util.buildVscodeMarketplaceExtension.hash attribute"
    argparse --max-args 0 h/help 'a/author=' 'n/name=' 'v/version=' -- $argv
    or return
    if set -q _flag_help; or test (count $argv_opts) -eq 0
        echo "\
Generate valid hash for build vscode extension with nix.

Usage:
    nix-vscode-extension-hash -a <author> -n <name> -v <version>
    nix-vscode-extension-hash --author=<author> --name=<name> --version=<version>
    nix-vscode-extension-hash -h | --help"
        return 0
    end

    if not set -ql _flag_author _flag_name _flag_version
        echo "error: required options not set" >&2
        return 1
    end

    set -l hash (nix-prefetch-url --type sha256 \
        "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$_flag_author/vsextensions/$_flag_name/$_flag_version/vspackage")
    set hash (echo $hash | tail -1)
    set -l hash64 (nix-hash --type sha256 --to-base64 "$hash")
    echo "sha256-$hash64"
end

# VS Code

The [custom Home Manager module](../../modules/home-manager/darwin/vscode.nix)
keeps profiles in Nix and copies their files so that VS Code can edit them.
It also lets [extensions write their own files](https://github.com/nix-community/home-manager/issues/7188).
Homebrew installs the editor separately.

Changes made in the editor remain until activation restores the declared files.
Keep permanent changes in Nix, including extensions installed through the
editor.

## How it works

`aerz.vscode.profiles` declares `settings` and `extensions` for each profile.
The `default` entry maps to VS Code's main profile.

Profiles live under `~/Library/Application Support/Code/User` on macOS.
They share files under `~/.vscode/extensions` and use separate
`extensions.json` lists. Keep shared extensions at the same version across
profiles.

Activation copies nonempty settings to `settings.json` and registers named
profiles in `globalStorage/storage.json`. It copies the combined extensions
with `rsync --delete` and grants write access. When extensions are managed,
this removes undeclared extensions from the shared directory.

The module skips file writes for empty settings or extension lists.
Removing a profile declaration leaves its registration and directory in place.

## Usage

Import this module from your Home Manager configuration. Its path assumes
a file directly under `home/`, like [home/vscode.nix](../../home/vscode.nix):

```nix
{ pkgs, ... }: {
  imports = [ ../modules/home-manager/darwin/vscode.nix ];

  aerz.vscode = {
    enable = true;
    profiles.default = {
      settings."editor.formatOnSave" = true;
      extensions = [ pkgs.vscode-extensions.jnoortheen.nix-ide ];
    };
  };
}
```

## Extension sources

The profiles combine `pkgs.vscode-extensions` with
[nix4vscode](https://github.com/nix-community/nix4vscode), which selects
extensions by Marketplace identifier. The
[local overlay](../../overlays/vscode-extensions.nix) adds packages or pins
versions independently of nixpkgs.

`pkgs.nix4vscode.forVscode` needs the nix4vscode input and overlay.
[overlays/default.nix](../../overlays/default.nix) selects the overlays, and
[modules/overlays.nix](../../modules/overlays.nix) applies them.

The [Fish helper](../../home/fish/functions/nix-vscode-extension-hash.fish)
prints a `mktplcRef` block from Marketplace metadata. It needs Fish, curl,
jq, `nix-prefetch-url`, and `nix-hash`. Run it from a Fish shell at the
repository root:

```fish
source home/fish/functions/nix-vscode-extension-hash.fish
nix-vscode-extension-hash jnoortheen.nix-ide
```

Use `--version` for a release or `--pre-release` for a preview.
`--target-platform` accepts `darwin-arm64`, `linux-arm64`, and `linux-x64`.
See `--help` for examples.

Put its output inside a `buildVscodeMarketplaceExtension` call in the
overlay. Add the package to the profile. The helper does not edit
files.

Native extensions need a matching platform and hash. The Python Environments
entry only provides a `darwin-arm64` hash. Add hashes before using it on
another platform.

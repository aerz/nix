# MAS overlay

> Status: archived (2026-08-27, aa3681a, nixpkgs now ships mas >= 7.0.0)

This [overlay](../../overlays/mas.nix) pinned a newer
[mas-cli release](https://github.com/mas-cli/mas/releases) while nixpkgs lagged
behind. The old CLI made nix-darwin's Homebrew integration and the
[MAS module](../modules/mas.md) unreliable.

It replaces `pkgs.mas` with a package that unpacks the official `.pkg`
release.

## Usage

The entry in `overlays/default.nix` is commented out. To reuse it, restore
the import:

```nix
# overlays/default.nix
overlays = {
  mas = import ./mas.nix;
};
```

Before activation, update `version` and the hashes for each architecture in
`overlays/mas.nix`. After activation, make sure that the command below reports
the selected version:

```console
$ mas --version
```

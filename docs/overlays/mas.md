# Mas Overlay

> Status: archived (2026-08-27, aa3681a, nixpkgs now ships mas >= 7.0.0)

## Overview

Pin `pkgs.mas` to the then-latest mas-cli release while nixpkgs lagged
behind.

## Background

nixpkgs-unstable kept an old mas-cli for months. The brew bundle mas
extension (and therefore nix-darwin's MAS integration) depends on that
binary, and the [mas module](../modules/mas.md) calls it directly at Home
Manager activation; a stale version made both unreliable. The overlay
builds the official mas-cli `.pkg`, so `pkgs.mas` is always the version we
decided to run.

## How it works

Overrides `mas` in `nixpkgs.overlays` with a derivation that unpacks the
official mas-cli `.pkg` release (see `overlays/mas.nix`).

## Usage

Import the overlay in `overlays/default.nix`:

```nix
# overlays/default.nix
overlays = {
  mas = import ./mas.nix;
};
```

The entry is currently commented out. Before use, bump `version` and the
per-arch hashes in `overlays/mas.nix` to the release you need, then check
that `mas --version` reports the pinned version:

```console
$ mas --version
```

## References

- [overlays/mas.nix](../../overlays/mas.nix)
- [mas-cli releases](https://github.com/mas-cli/mas/releases)

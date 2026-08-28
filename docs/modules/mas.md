# Mas Home-Manager Module

> Status: archived (2026-08-28, f688b5b, superseded by nix-homebrew `homebrew.masApps`)

## Overview

Manage Mac App Store apps through Home Manager activation using the `mas` CLI
directly, bypassing the brew bundle integration of nix-darwin.

## Background

mas-cli changed its command behavior in 2026 and the official nix-darwin
homebrew module (which relies on brew bundle's mas extension) broke with it.
Upstream took months (March to July) to adapt, so we wrote our own module:

- [nix-darwin/nix-darwin#1722](https://github.com/nix-darwin/nix-darwin/issues/1722)
- [Homebrew/brew#21559](https://github.com/Homebrew/brew/issues/21559)

## How it works

Defines the `aerz.masApps` option (app name → App Store id). At activation it
runs `mas get <id>` / `mas upgrade <id>` for each declared app
(`MAS_NO_AUTO_INDEX=1` so the app list stays under our control). The binary
comes from `pkgs.mas`; the [mas overlay](../overlays/mas.md) pinned its
version while nixpkgs lagged.

## Usage

Import the module from any home-manager config and declare the apps you
manage:

```nix
# home config
imports = [ ../modules/home-manager/darwin/mas.nix ];

aerz.masApps = {
  "TickTick" = 966085870;
};
```

The module is archived, so nothing imports it today. To use it again, add
the import above to any home-manager config. If brew bundle's MAS
integration is still broken, bring the [mas overlay](../overlays/mas.md)
back alongside it; the module calls `mas` from `pkgs` and needs a working
binary.

## References

- [modules/home-manager/darwin/mas.nix](../../modules/home-manager/darwin/mas.nix)
- [mas-cli](https://github.com/mas-cli/mas)
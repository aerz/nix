# MAS Home Manager module

> Status: archived (2026-08-28, f688b5b, superseded by nix-darwin `homebrew.masApps`)

This [module](../../modules/home-manager/darwin/mas.nix) manages Mac App Store
applications through Home Manager with the [mas CLI](https://github.com/mas-cli/mas).
It bypasses nix-darwin's Homebrew integration.

mas-cli changed its commands in 2026 and broke nix-darwin's Homebrew
integration. I used this module while upstream adapted the integration
between March and July. See
[nix-darwin#1722](https://github.com/nix-darwin/nix-darwin/issues/1722) and
[Homebrew#21559](https://github.com/Homebrew/brew/issues/21559).

## How it works

`aerz.masApps` maps application names to App Store IDs. Activation runs
`mas get <id>` / `mas upgrade <id>` with `MAS_NO_AUTO_INDEX=1` to control
the application list. It uses `pkgs.mas`, previously pinned through the
[MAS overlay](../overlays/mas.md).

## Usage

To reuse it, import the module and declare applications in Home Manager:

```nix
# home config
imports = [ ../modules/home-manager/darwin/mas.nix ];

aerz.masApps = {
  "TickTick" = 966085870;
};
```

The current configuration does not import this module. Before you reuse it, make
sure that `pkgs.mas` works. If you need another version, adapt the
[MAS overlay](../overlays/mas.md).

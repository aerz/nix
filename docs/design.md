# Design

I keep the shared configuration for my systems in this repository.
The current host is
[alterac](../hosts/alterac/), running macOS on Apple Silicon.

## Shared configuration and hosts

[flake.nix](../flake.nix) connects external modules to each host under
`hosts/`. Each host imports user configuration from
[home/default.nix](../home/default.nix) and custom modules from `modules/`.
[overlays/default.nix](../overlays/default.nix) selects overlays, which add
or change packages in nixpkgs.

A Linux host needs a NixOS or standalone Home Manager output and an import
list adapted to its programs and paths. The flake does not export a template
or a public module interface.

## Nix, macOS, and Homebrew

| Tool | Responsibility in this repository |
| --- | --- |
| Determinate Nix | The Nix installation and its daemon. |
| nix-darwin | macOS preferences, system packages, and system activation. |
| Home Manager | User programs, configuration files, and activation steps. |
| nix-homebrew | The Homebrew installation and pinned tap sources. |
| nix-darwin's `homebrew` module | Formulae, casks, and Mac App Store applications. |

I first installed upstream Nix, then moved to Determinate through its macOS
installer. The host sets `nix.enable = false` to leave the Nix installation
to Determinate. Nix options go in `determinateNix.customSettings`, as
described in the [integration guide](https://docs.determinate.systems/guides/nix-darwin/).

I declare command-line tools through Nix and many macOS applications through
Homebrew. Homebrew installs VS Code, while Home Manager manages its profiles.
[Emacs Plus](modules/emacs.md) also uses both system and user configuration.

I pin Homebrew separately from its taps, the repositories of package
definitions. This lets me update either source to resolve compatibility
problems.
See [maintenance](maintenance.md#homebrew-and-its-taps) for the update paths.

## Writable files where programs need them

The [VS Code module](modules/vscode.md) copies profiles and extensions out
of the Nix store so that the editor can write to them. I can experiment
locally, then keep permanent changes in Nix. Activation restores the
declared files.

Homebrew upgrades and `pmset` changes also affect state outside the Nix
store. System generations do not capture that state. See the
[rollback limits](maintenance.md#activation-and-rollback).

## Development environments

The host and Home Manager supply everyday tools and shared editor
dependencies. Projects can define their own development shells with the
tools that they need.

[home/direnv.nix](../home/direnv.nix) enables direnv and nix-direnv to load
those environments when I enter a project directory. A project with a flake
can use `use flake` in its `.envrc`. This repository does not define a
development shell of its own.

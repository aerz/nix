> A hearthstone for my systems, written in Nix.

I use this repository as a common base for configuring my systems with Nix.
[Home Manager](docs/design.md#shared-configuration-and-hosts) provides the
shared user configuration. Each host adds its own system configuration, with
[nix-darwin and nix-homebrew](docs/design.md#nix-macos-and-homebrew) for macOS.

## Machines

| Name | Platform | Role |
| --- | --- | --- |
| [alterac](hosts/alterac/) | macOS (`aarch64-darwin`) | Daily use and development. |

## Project Structure

Each host selects its system modules and imports the user configuration from
[home/default.nix](home/default.nix). That file selects the programs and their
configuration.

```text
.
├── flake.nix
├── flake.lock
├── hosts/
│   └── alterac/
├── home/
├── modules/
│   ├── darwin/
│   └── home-manager/darwin/
├── overlays/
├── docs/
└── justfile
```

## Configuration

I use standard Home Manager modules for most programs. Custom modules cover
the cases that need a different approach, such as writable VS Code profiles
and Emacs Plus. Local overlays add or update VS Code extensions.

| Component | Approach |
| --- | --- |
| [VS Code](docs/modules/vscode.md) | I keep [profiles](home/vscode.nix) in Nix and copy their files so VS Code can edit them. Rebuilds restore declared values and remove undeclared extensions, so I keep permanent changes in Nix. |
| [AeroSpace](docs/modules/aerospace.md) | I use [Swift scripts](home/aerospace/scripts) to center, move, and resize floating windows because AeroSpace [does not prioritize those controls](https://github.com/nikitabobko/AeroSpace/discussions/633). Nix compiles them and binds them to a floating mode. They require Accessibility permission. |
| [VS Code extensions](docs/modules/vscode.md#extension-sources) | When nixpkgs lacks an extension or the version I need, I use a local overlay. A [Fish helper](home/fish/functions/nix-vscode-extension-hash.fish) generates the version, platform, and hash fields from Marketplace metadata. The profiles also use [nix4vscode](https://github.com/nix-community/nix4vscode) to select extensions by identifier. |
| [Emacs Plus](docs/modules/emacs.md) | Homebrew dependency updates can leave Emacs unable to load. The module tests the executable and attempts a rebuild from source if it fails, then copies the application bundles into `/Applications`. |
| [Homebrew](docs/maintenance.md#homebrew-and-its-taps) | Homebrew and its package definitions can need updates at different times. I pin [Homebrew itself](flake.nix) and its taps separately so I can update either source without changing the other. |
| [Power management](modules/darwin/power-management.nix) | I keep sleep-related `pmset` changes in a module so rebuilds reapply them. Disabling the module does not undo those changes. |

## Usage

For a new macOS setup, follow the [macOS installation guide](docs/installation-mac.md).
The [documentation](docs/README.md) covers the design and custom modules.

To use this repository as a base:

1. Add your host under [hosts/](hosts/) and declare it in [flake.nix](flake.nix).
2. Set your username, home directory, and [Git identity](home/git.nix) in the host and home configuration.
3. Select the programs in [home/default.nix](home/default.nix) and adapt platform-specific imports and paths.

For Linux, use a NixOS or standalone Home Manager output. The current build
and switch tasks target nix-darwin.

To reuse one piece, copy its module or overlay with the scripts and flake
inputs that it needs. The [overlays/default.nix](overlays/default.nix) file
selects the active overlays.

## Commands

| Command | Action |
| --- | --- |
| `just` | Update dependencies, then build and switch. |
| `just build alterac` | Build without switching. |
| `just trace alterac` | Build with `--show-trace`. |
| `just switch` | Build and switch. |
| `just rollback` | Activate the previous system generation. |
| `just update` | Update dependencies in `flake.lock`. |
| `just update-sources` | Update fetched source revisions and hashes. |
| `just clean` | Run `nix flake check --no-build`. |
| `just gc` | Delete old generations and optimize the Nix store. |
| `just repair` | Inspect the Nix store and attempt repairs. |

In the [justfile](justfile), `build` and `trace` default to the current host
when no host is supplied. See [maintenance](docs/maintenance.md) for source
pins, activation behavior, and recovery.

# Documentation

These guides cover installation, design decisions, and the custom modules.

| Guide | Content |
| --- | --- |
| [macOS installation](installation-mac.md) | Set up a host and apply the configuration for the first time. |
| [Design](design.md) | Understand the shared configuration, system boundaries, and package sources. |
| [Maintenance](maintenance.md) | Update dependencies, manage pinned sources, and recover from known problems. |
| [VS Code](modules/vscode.md) | Use writable profiles and select or package extensions. |
| [Raycast](modules/raycast.md) | Copy executable scripts through a custom Home Manager module. |
| [AeroSpace](modules/aerospace.md) | Add controls for floating windows through Swift scripts. |
| [Emacs Plus](modules/emacs.md) | Integrate the Homebrew build and recover from broken library dependencies. |

## Archive

Notes on solutions that this configuration no longer uses.

- [MAS module](modules/mas.md): Manage Mac App Store applications through Home Manager when the Homebrew integration fails.
- [MAS overlay](overlays/mas.md): Package a newer mas-cli release while the version in nixpkgs lags behind.

# macOS installation

## Prepare macOS

Install the Xcode Command Line Tools:

```sh
xcode-select --install
```

Install Nix with the [Determinate macOS installer](https://docs.determinate.systems/).
If Nix is already installed, follow the
[Determinate migration guide](https://docs.determinate.systems/guides/migrating-from-upstream-nix/).
Open a new terminal. Run `nix --version`.

If you keep the declared Mac App Store applications, sign in to the App
Store before activation. The host uses native Homebrew with
`nix-homebrew.enableRosetta = false`.

## Prepare the configuration

Work in a directory you own. Replace `my-mac` with your host name.
The `just` tasks use the name reported by `hostname -s`.

Clone the repository and copy the existing host:

```sh
git clone https://github.com/aerz/nix.git nix-config
cd nix-config
cp -R hosts/alterac hosts/my-mac
```

In [flake.nix](../flake.nix), copy the `darwinConfigurations.alterac` output
to `darwinConfigurations.my-mac`. Change its host module to `./hosts/my-mac`.
Keep the imported Home Manager, nix-homebrew, and Determinate modules.

Adapt these values before the first build:

| File | Values to adapt |
| --- | --- |
| `hosts/my-mac/default.nix` | The Home Manager user, macOS user, home directory, and shell. |
| `hosts/my-mac/settings.nix` | `system.primaryUser`, system preferences, and application paths. |
| `hosts/my-mac/brew.nix` | `nix-homebrew.user`, the Home Manager user in `extraEnv`, and the application lists. |
| [home/default.nix](../home/default.nix) | `home.username` and the selected imports. |
| [home/git.nix](../home/git.nix) | The Git name and email address. |

Custom option names such as `aerz.vscode` and `aerz.power-management` do not
refer to a macOS account. Changes under `home/` affect every host that imports it.
Keep `nix.enable = false` while Determinate manages Nix, as explained in
[design](design.md#nix-macos-and-homebrew).

Review the imports and application lists before activation. In particular,
Homebrew activation upgrades packages and uses `cleanup = "zap"`.
It can remove undeclared packages and associated application data.
See [activation and rollback](maintenance.md#activation-and-rollback).

Add the new host files to Git so that the flake includes them:

```sh
git add hosts/my-mac
```

## Build and activate

From the repository root, build the new host:

```sh
nix build .#darwinConfigurations.my-mac.system
```

The build creates `result` without activating the configuration.
Activate with the bundled `darwin-rebuild`:

```sh
sudo ./result/sw/bin/darwin-rebuild switch --flake .#my-mac
```

Activation also applies Home Manager and installs Homebrew. The host sets
`autoMigrate = true` to adopt an existing Homebrew installation.

## Finish the setup

Grant Accessibility access for the
[AeroSpace window controls](modules/aerospace.md#permissions-and-dependencies)
under System Settings → Privacy & Security → Accessibility.

If macOS rejects Fish as a login shell, make sure that its path appears in
`/etc/shells`. See the related
[nix-darwin issue](https://github.com/nix-darwin/nix-darwin/issues/1237).

For later changes, see the [commands](../README.md#commands) and
[maintenance notes](maintenance.md).

## References

- [nix-darwin installation](https://github.com/nix-darwin/nix-darwin#getting-started)
- [Determinate with nix-darwin](https://docs.determinate.systems/guides/nix-darwin/)
- [nix-homebrew installation and migration](https://github.com/zhaofengli/nix-homebrew)

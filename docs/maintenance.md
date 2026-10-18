# Maintenance

Run these examples from the repository root. The
[README](../README.md#commands) lists all daily commands.

## Flake dependencies

`just update` updates `flake.lock`. Explicit nixpkgs and Homebrew revisions
in `flake.nix` stay fixed until you edit their input URLs and update the
lock file.

To review an update, inspect the lock file and build before activation:

```sh
just update
git diff -- flake.nix flake.lock
just build alterac
```

Replace `alterac` with your host name. The default `just` task updates and
switches immediately, without a review step.

## Homebrew and its taps

| Source | Location | Update method |
| --- | --- | --- |
| Homebrew itself | The `brew-src` input override in [flake.nix](../flake.nix). | Change the revision in the URL, then update `flake.lock`. |
| Tap definitions | `fetchFromGitHub` calls in [brew.nix](../hosts/alterac/brew.nix) and the [Emacs module](../modules/darwin/emacs.nix). | Update each revision and its matching hash. |

`just update-sources` runs `update-nix-fetchgit` across the Nix files.
Review its diff before building, especially for revisions pinned to specific
fixes. It can change multiple sources, but not the `brew-src` input URL.

With `mutableTaps = false`, tap changes belong in Nix. Activation updates
packages without replacing the Homebrew executable selected by `brew-src`.
If a formula fails to parse, compare the Homebrew and tap revisions first.

## Extensions and the Nix installation

nix4vscode's version follows its flake input. The local VS Code overlay keeps
separate versions and hashes that `just update` does not rewrite. Use the
[extension helper](modules/vscode.md#extension-sources) to update those entries.

Updating `flake.lock` does not update the Nix installation, which Determinate
manages. Run `determinate-nixd version` for the installed version and upgrade
instructions.
See the [Nixd documentation](https://docs.determinate.systems/determinate-nixd/).

## Activation and rollback

Activation applies Home Manager, macOS preferences, and Homebrew operations.
Homebrew enables upgrades and `cleanup = "zap"`, which can remove undeclared
packages and associated application data.

`just rollback` activates the previous system generation and runs Homebrew
operations again. It does not restore a snapshot of Homebrew package versions
or application data. The VS Code module also replaces its managed files.
Keep permanent editor changes in Nix before switching.

Disabling the [power management module](../modules/darwin/power-management.nix)
does not reset its `pmset` changes. Set the intended values explicitly when
reversing that configuration.

`just gc` deletes old generations and unused store paths. Keep previous
generations while you assess an update so that rollback remains available.

## GPG reports "No pinentry"

pinentry asks for GPG passphrases. After an update or garbage collection,
a running GPG agent can retain an old pinentry path and report:

```text
gpg: public key decryption failed: No pinentry
gpg: decryption failed: No pinentry
```

Read the agent configuration from the active GPG home:

```sh
gpgconf --list-dirs homedir
cat "$(gpgconf --list-dirs homedir)/gpg-agent.conf"
```

Make sure that `pinentry-program` points to an existing executable.
If the file contains a missing store path, reapply the
[GPG configuration](../home/gpg.nix) first.

If the path exists, restart the agent so that it reads the current file:

```sh
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
```

Retry the failed operation. If it still fails, inspect the active home and
pinentry executable before changing the Nix configuration.

# Emacs Plus

The [system module](../../modules/darwin/emacs.nix) installs
[Emacs Plus](https://github.com/d12frosted/homebrew-emacs-plus) through
Homebrew and copies its applications into `/Applications`.
Homebrew library updates can leave Emacs unable to load before it reads
the user configuration. I keep a recovery step in system activation to
handle that failure alongside package updates.

## How it works

The module pins the `d12frosted/homebrew-emacs-plus` tap and declares
`emacs-plus@31` with its supporting tools and libraries.

After package operations, activation tests the executable with
`-Q --batch --version`, without user initialization files. If the executable
exists but fails, activation runs `brew reinstall --yes --build-from-source` as the
Homebrew owner. If that command fails, it attempts `brew postinstall` once.

Activation repeats the test after recovery. It stops if the test fails or
either application bundle is missing. Otherwise, activation replaces
`/Applications/Emacs.app` and `/Applications/Emacs Client.app` with copies
from Homebrew. This startup test does not load or test Doom configuration.

## Usage

Import the system module from a host under `hosts/`:

```nix
{
  imports = [ ../../modules/darwin/emacs.nix ];
}
```

The host needs the nix-homebrew flake module, `nix-homebrew.enable`,
`nix-homebrew.user`, and `homebrew.enable`. See
[alterac](../../hosts/alterac/default.nix) and its
[Homebrew configuration](../../hosts/alterac/brew.nix).

The optional [user configuration](../../home/emacs.nix) writes the icon choice
to `emacs-plus/build.yml` and adds `~/.config/emacs/bin` to the session path.
Doom and its configuration are separate from this repository.

## Diagnose a startup failure

Test the Homebrew executable before investigating editor configuration:

```sh
"$(brew --prefix emacs-plus@31)/Emacs.app/Contents/MacOS/Emacs" -Q --batch --version
```

If a library is missing, inspect the Homebrew dependencies and activation
output. If the test succeeds, investigate the editor configuration.

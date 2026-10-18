# AeroSpace floating windows

I use Swift scripts to center, move, and resize floating windows alongside
AeroSpace's tiling. Its maintainer does not prioritize those controls, as
explained in [discussion #633](https://github.com/nikitabobko/AeroSpace/discussions/633).
The scripts use macOS Accessibility APIs without changing AeroSpace itself.

## How it works

[home/aerospace/default.nix](../../home/aerospace/default.nix) compiles the
scripts with `pkgs.swift` and installs them in the Nix store. AeroSpace
bindings call wrappers under `~/.config/aerospace/`.

| Script | Behavior |
| --- | --- |
| [center-floating](../../home/aerospace/scripts/center-floating.swift) | Centers the window in the visible area of the first screen that it intersects. |
| [move-floating](../../home/aerospace/scripts/move-floating.swift) `<dy> <dx>` | Moves the window. Positive `dy` moves up, and positive `dx` moves right. |
| [resize-floating](../../home/aerospace/scripts/resize-floating.swift) `<deltaWidth> <deltaHeight>` | Changes the dimensions and adjusts the position to preserve the center. |

Use the scripts on the focused floating window. They do not change or test
its layout, so tiling can override their changes. Applications can also
restrict movement or resizing.

## Usage

From a Home Manager module directly under `home/`, import the directory:

```nix
{
  imports = [ ./aerospace ];
}
```

To reuse the setup, copy the directory, including `scripts/`, and adapt its
bindings and application rules. For the controls alone, keep the Swift build
expression and bind its executables in your own configuration.

`alt-shift-f` toggles floating and tiling. `alt-shift-period` enters floating
mode, where `c` centers, `h/j/k/l` move, and `shift-h/j/k/l` resize the window.
`esc` returns to main mode, while `f` returns the window to tiling.

## Permissions and dependencies

Without Accessibility permission, the scripts report
`Accessibility permission is required to control windows`.
Grant access under System Settings → Privacy & Security → Accessibility
for the application or executable that macOS identifies as the caller.

The wrappers call a Raycast `toast` script command that is not included in
this repository.
Other bindings use Raycast for preset sizes and thirds. If you do not use
Raycast, remove those bindings and toast calls. The Swift executables have
no dependency on Raycast.

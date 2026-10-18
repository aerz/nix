# Raycast

The [custom Home Manager module](../../modules/home-manager/darwin/raycast.nix)
copies [scripts](../../home/raycast/scripts/) as writable, executable files
because Raycast does not read symbolic links.

Configure [home/raycast/default.nix](../../home/raycast/default.nix):

```nix
{config, ...}: {
  imports = [
    ../../modules/home-manager/darwin/raycast.nix
  ];

  raycast = {
    enable = true;
    source = ./scripts;
    target = "${config.home.homeDirectory}/Documents/Raycast/Scripts";
  };
}
```

Each Home Manager activation updates matching files and keeps additional target files.
Keep permanent edits in `source` and configure Raycast to read `target`.

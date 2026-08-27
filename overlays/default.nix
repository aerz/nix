{inputs}: let
  inherit (inputs.nixpkgs) lib;

  overlays = {
    nix4vscode = inputs.nix4vscode.overlays.default;
    vscode-extensions = import ./vscode-extensions.nix;
    # mas = import ./mas.nix;
  };
in
  lib.attrValues overlays
